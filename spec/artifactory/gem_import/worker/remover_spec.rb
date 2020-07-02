RSpec.describe Artifactory::GemImport::Worker::Remover do
  let(:target_repo) {
    Artifactory::GemImport::Repo.new url: "https://artifactory.local/gems-local", headers: {}
  }

  let(:fixture_spec) {
    File.open "spec/fixtures/specs.4.8.gz"
  }

  describe "#remove" do
    it "always skips gems the Artifactory repo requires to work properly" do
      remover = described_class.new(target_repo: target_repo)

      expect(remover).to receive(:gems).and_return [
                                                     instance_double(Artifactory::GemImport::Gem, name: "rubygems-update",
                                                                                                  version: "2.0.6",
                                                                                                  filename: "rubygems-update-2.0.2.gem"),
                                                   ]
      expect(remover).not_to receive(:remove)

      expect(remover.remove!).to eq({ skipped: 1 })
    end

    context "Server responds as expected" do
      before do
        stub_request(:get, "https://artifactory.local/gems-local/specs.4.8.gz")
          .to_return(status: 200, body: fixture_spec)

        stub_request(:delete, /artifactory.local/).to_return status: [204, nil]
      end

      it "removes all gems from the target artifactory" do
        remover = described_class.new(target_repo: target_repo)

        expect(remover.remove!).to eq({ removed: 4 })
      end

      it "removes gems matching the :only expression from the target repo" do
        remover = described_class.new(target_repo: target_repo, only: "^example")

        expect(remover.remove!).to eq({ removed: 3 })
      end
    end

    context "Specs can not be retrieved" do
      before do
        stub_request(:get, "https://artifactory.local/gems-local/specs.4.8.gz")
          .to_timeout
      end

      it "raises ClientError" do
        remover = described_class.new(target_repo: target_repo)

        expect { remover.remove! }.to raise_error Artifactory::GemImport::ClientError
      end
    end

    context "Server error on gem deletion" do
      let(:remover) { described_class.new(target_repo: target_repo) }

      before do
        stub_request(:get, "https://artifactory.local/gems-local/specs.4.8.gz")
          .to_return(status: 200, body: fixture_spec)

        stub_request(:delete, /\/example/).to_return status: [204, nil]

        stub_request(:delete, /\/other-example/).to_return status: [404, "Not found"]
      end

      it "handles server errors" do
        expect(remover.remove!).to eq({ removal_failed: 1, removed: 3, review: ["other-example-0.1.0.gem"] })
      end
    end
  end
end
