require "httparty"

module Artifactory
  module GemImport
    module GemSpecs
      class Downloader
        def self.call(url, headers: {})
          new(url, headers).call
        end

        attr_reader :url, :headers

        def initialize(url, headers)
          @url = url
          @headers = headers
        end

        def call
          response = HTTParty.get url,
                                  headers: headers

          if response.success?
            response.body
          else
            response.error!
          end
        end
      end
    end
  end
end
