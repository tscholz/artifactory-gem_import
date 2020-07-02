RSpec.describe Artifactory::GemImport::GemSpecs do
  let(:repo) {
    Artifactory::GemImport::Repo.new(url: "https://gem-repo.local", headers: {})
  }

  let(:fixture_file) { "spec/fixtures/specs.4.8.gz" }

  let(:gem_examples) do
    [
      ["example", Gem::Version.new("0.0.1"), "ruby"],
      ["example", Gem::Version.new("0.0.2"), "ruby"],
      ["example", Gem::Version.new("0.0.2"), "java"],
      ["other-example", Gem::Version.new("0.1.0"), "ruby"],
    ]
  end

  describe "::get" do
    it "returns specs" do
      stub_request(:get, "https://gem-repo.local/specs.4.8.gz").to_return(status: 200, body: File.open(fixture_file))

      expect(described_class.get(repo: repo)).to contain_exactly *gem_examples
    end

    it "raises ClientError on server error" do
      stub_request(:get, "https://gem-repo.local/specs.4.8.gz")
        .to_return(status: [500, "Internal Server Error"])

      expect {
        described_class.get repo: repo
      }.to raise_error Artifactory::GemImport::ClientError, /Could not fetch specs./
    end

    it "raises ClientError if specs file not found" do
      stub_request(:get, "https://gem-repo.local/specs.4.8.gz")
        .to_return(status: [404, "Not found"])

      expect {
        described_class.get repo: repo
      }.to raise_error Artifactory::GemImport::ClientError, /Could not fetch specs./
    end
  end

  describe "::missing_gems" do
    it "returns the diff of two specs" do
      other_specs = [
        ["example", Gem::Version.new("0.0.1"), "ruby"],
        ["other-example", Gem::Version.new("0.1.0"), "ruby"],
      ]

      expect(described_class).to receive(:get).twice.and_return gem_examples, other_specs

      expect(
        described_class.missing_gems source_repo: double(), target_repo: double()
      ).to contain_exactly ["example", Gem::Version.new("0.0.2"), "ruby"], ["example", Gem::Version.new("0.0.2"), "java"]
    end
  end
end
