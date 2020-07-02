require "tempfile"
require "digest"

module Artifactory
  RSpec.describe GemImport::Gems::Verifier do
    around do |example|
      Tempfile.create("my-gem-0.1.0.gem") do |file|
        @file = file
        @file.write "Hello World"
        @file.rewind
        example.run
      end
    end

    let(:verifier) { described_class.new }

    let(:expected_md5) {
      Digest::MD5.hexdigest(@file.read).tap { @file.rewind }
    }

    describe "#call" do
      it "verifies successful" do
        # kept relevant information only...
        representation = { "checksums" => { "md5" => expected_md5 } }

        expect(
          verifier.call(@file.path, representation)
        ).to eq [:ok]
      end

      it "does not verify successful" do
        # kept relevant information only...
        representation = { "checksums" => { "md5" => "xyz" } }

        status, message = verifier.call @file.path, representation

        expect(status).to eq :failed
        expect(message).to match /Checksum comparison for uploaded gem .+ failed./
      end
    end
  end
end
