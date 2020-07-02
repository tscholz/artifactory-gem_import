module Artifactory
  module GemImport
    module GemSpecs
      class Specs
        def self.filter(specs, only:)
          specs.select { |spec| spec.first =~ Regexp.new(only) }
        end

        def initialize(url:, headers: {})
          @url = url
          @headers = headers
        end

        def specs
          @specs ||= Parser.call fetch_specs
        end

        private

        def fetch_specs
          Downloader.call @url, headers: @headers
        end
      end
    end
  end
end
