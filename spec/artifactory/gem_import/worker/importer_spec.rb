RSpec.describe Artifactory::GemImport::Worker::Importer do
  describe "#import" do
    let(:importer) {
      described_class.new source_repo: source_repo,
                          target_repo: target_repo
    }

    let(:source_repo) {
      Artifactory::GemImport::Repo.new url: "http://source-repo.local",
                                       headers: {}
    }

    let(:target_repo) {
      Artifactory::GemImport::Repo.new url: "http://target_repo.local/gems-local",
                                       headers: {}
    }

    it "does nothing if all gems already imported" do
      fixture_spec = "spec/fixtures/specs.4.8.gz"

      stub_request(:get, source_repo.specs_url).to_return status: 200, body: File.open(fixture_spec)

      stub_request(:get, target_repo.specs_url).to_return status: 200, body: File.open(fixture_spec)

      expect(importer.import!).to eq({})
    end

    it "downloads missing gems"

    it "uploads missing gems"

    it "verifies uploaded gems"

    it "deletes invalid uploaded gems with a wrong checksum"

    it "tracks gems for review if deletion failed"

    it "outputs a summary"
  end
end
