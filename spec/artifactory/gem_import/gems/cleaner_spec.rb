module Artifactory
  RSpec.describe GemImport::Gems::Cleaner do
    let(:remover) { described_class.new }

    let(:gem_url) { "http://source-repo.local/gems-local/gems/my-gem-0.1.0.gem" }

    describe "#call" do
      it "successful removes file from remote" do
        stub_request(:delete, gem_url).to_return(status: [204, nil])

        expect(remover.call gem_url, {}).to eq [:ok, gem_url]
      end

      it "handles server errors" do
        stub_request(:delete, gem_url)
          .to_return(status: [500, "Internal Server Error"])

        expect(remover.call gem_url, {}).to eq [:error, "500 \"Internal Server Error\""]
      end

      it "handles not found errors" do
        stub_request(:delete, gem_url)
          .to_return(status: [404, "Not found"])

        expect(remover.call gem_url, {}).to eq [:error, "404 \"Not found\""]
      end

      it "handles timeouts" do
        stub_request(:delete, gem_url).to_timeout

        expect(remover.call gem_url, {}).to eq [:error, "execution expired"]
      end
    end
  end
end
