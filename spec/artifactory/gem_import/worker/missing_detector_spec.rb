RSpec.describe Artifactory::GemImport::Worker::MissingDetector do
  describe "#detect" do
    let(:detector) {
      described_class.new source_repo: double(),
                          target_repo: double()
    }

    let(:missing_gems) {
      [
        ["example", Gem::Version.new("0.0.1"), "ruby"],
        ["example", Gem::Version.new("0.0.2"), "ruby"],
      ]
    }

    it "returns the filename of gems missing in the target repo" do
      expect(Artifactory::GemImport::GemSpecs).to receive(:missing_gems).and_return missing_gems

      expect(detector.detect!).to contain_exactly "example-0.0.1.gem", "example-0.0.2.gem"
    end
  end
end
