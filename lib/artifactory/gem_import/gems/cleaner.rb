module Artifactory
  module GemImport
    module Gems
      class Cleaner
        def call(url, headers)
          [:ok, cleanup(url, headers)]
        rescue Net::HTTPClientException, Net::HTTPFatalError, Net::OpenTimeout, SocketError => err
          [:error, err.message]
        end

        private

        def cleanup(url, headers)
          response = HTTParty.delete url, headers: headers

          response.success? ? url : response.error!
        end
      end
    end
  end
end
