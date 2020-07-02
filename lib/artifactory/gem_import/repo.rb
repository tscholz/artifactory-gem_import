module Artifactory
  module GemImport
    class Repo
      attr_reader :url, :headers

      def initialize(url:, headers:)
        @url = url
        @headers = headers
      end

      def gems_url
        File.join url, "gems", "/"
      end

      def specs_url
        File.join url, "specs.4.8.gz"
      end
    end
  end
end
