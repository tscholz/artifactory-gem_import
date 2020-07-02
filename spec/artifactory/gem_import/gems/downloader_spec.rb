require "tmpdir"

module Artifactory
  RSpec.describe GemImport::Gems::Downloader do
    around do |example|
      Dir.mktmpdir("rspec-") do |dir|
        @temp_dir = dir
        example.run
      end
    end

    let(:downloader) { described_class.new }
    let(:gem_url) { "http://source-repo.local/gems-local/gems/my-gem-0.1.0.gem" }
    let(:file) { "#{@temp_dir}/my-gem-0.1.0.gem" }

    describe "#call" do
      it "downloads the gem file" do
        stub_request(:get, gem_url)
          .to_return(status: [200, ""])

        expect(downloader.call gem_url, file).to eq [:ok, gem_url]
      end

      it "handles server errors" do
        stub_request(:get, gem_url)
          .to_return(status: [500, "Internal Server Error"])

        expect(downloader.call gem_url, file).to eq [:error, "500 \"Internal Server Error\""]
      end

      it "handles not found errors" do
        stub_request(:get, gem_url)
          .to_return(status: [404, "Not found"])

        expect(downloader.call gem_url, file).to eq [:error, "404 \"Not found\""]
      end

      it "handles timeouts" do
        stub_request(:get, gem_url).to_timeout

        expect(downloader.call gem_url, file).to eq [:error, "execution expired"]
      end
    end
  end
end
