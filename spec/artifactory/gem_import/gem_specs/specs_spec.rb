RSpec.describe Artifactory::GemImport::GemSpecs::Specs do
  let(:specs) { described_class.new(url: url, headers: {}) }

  let(:url) { "https://my-repo.local/specs.4.8.gz" }

  let(:fixture_file) { "spec/fixtures/specs.4.8.gz" }

  let(:gem_examples) do
    [
      ["example", Gem::Version.new("0.0.1"), "ruby"],
      ["example", Gem::Version.new("0.0.2"), "ruby"],
      ["example", Gem::Version.new("0.0.2"), "java"],
      ["other-example", Gem::Version.new("0.1.0"), "ruby"],
    ]
  end

  describe "::filter" do
    it "filters specs by name" do
      expect(described_class.filter gem_examples, only: "^example").to contain_exactly *gem_examples.first(3)
    end
  end

  describe "#specs" do
    it "returns specs" do
      stub_request(:get, url).to_return(status: 200, body: File.open(fixture_file))

      expect(specs.specs).to contain_exactly *gem_examples
    end
  end
end
