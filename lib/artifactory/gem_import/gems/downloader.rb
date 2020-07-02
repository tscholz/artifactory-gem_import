require "httparty"

module Artifactory
  module GemImport
    module Gems
      class Downloader
        def call(url, filename)
          download url, filename
        rescue Net::HTTPClientException, Net::HTTPFatalError, Net::OpenTimeout, SocketError => err # TODO handle file (-system) errors
          [:error, err.message]
        else
          [:ok, url]
        end

        private

        def download(url, filename)
          File.open(filename, "w") do |file|
            response = HTTParty.get(url, stream_body: true, follow_redirects: true) do |fragment|
              file.write fragment
            end

            response.error! unless response.success?
          end
        end
      end
    end
  end
end
