require "tempfile"

module Artifactory
  RSpec.describe GemImport::Gems::Uploader do
    around do |example|
      Tempfile.create("my-gem-0.1.0.gem") do |file|
        @file = file
        example.run
      end
    end

    let(:uploader) { described_class.new }

    let(:gem_url) { "https://target-repo.local/gems-local/gems/my-gem-0.1.0.gem" }

    let(:foreign_data) do
      { "repo" => "gems-local",
        "path" => "/gems/my-gem-0.1.0.gem",
        "created" => "2020-06-30T15:33:03.262+02:00",
        "createdBy" => "me",
        "downloadUri" => "https://target-repo.local/gems-local/gems/my-gem-0.1.0.gem",
        "mimeType" => "application/x-rubygems",
        "size" => "11776",
        "checksums" => { "sha1" => "08e6892e1b659e0d1b6af94ce30ddedf08d981e3",
                         "md5" => "e6040e8bc12f211b61da6badbb9949eb",
                         "sha256" => "31d26aed2822a731a11d0ec4c8148778f73ffd93ad576b68fa2cd741415b9399" },
        "originalChecksums" => { "sha256" => "31d26aed2822a731a11d0ec4c8148778f73ffd93ad576b68fa2cd741415b9399" },
        "uri" => "https://target-repo.local/gems-local/gems/my-gem-0.1.0.gem" }
    end

    describe "#call" do
      it "uploads a gem" do
        stub_request(:put, gem_url)
          .with(headers: { "Content-Length" => @file.size.to_s, "Transfer-Encoding" => "chunked" })
          .to_return(body: foreign_data.to_json)

        expect(uploader.call gem_url, {}, @file.path).to eq [:ok, foreign_data]
      end

      it "handles upload errors" do
        stub_request(:put, gem_url)
          .to_return(status: [500, "Internal Server Error"])

        expect(uploader.call gem_url, {}, @file.path).to eq [:error, "500 \"Internal Server Error\""]
      end

      it "handles timeouts" do
        stub_request(:put, gem_url).to_timeout

        expect(uploader.call gem_url, {}, @file.path).to eq [:error, "execution expired"]
      end
    end
  end
end
