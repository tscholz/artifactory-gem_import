module Artifactory
  module GemImport
    class Repo
      attr_reader :url, :headers

      def initialize(url:, headers:)
        @url     = url
        @headers = headers
      end

      def gems_url
        File.join url, "gems", "/"
      end

      def prerelease_specs_url
        File.join url, "prerelease_specs.4.8.gz"
      end

      def specs_url
        File.join url, "specs.4.8.gz"
      end

      def latest_specs_url
        File.join url, "latest_specs.4.8.gz"
      end
    end
  end
end
