module Artifactory
  module GemImport
    module Gems
      class Uploader
        def call(url, headers, file_path)
          file = File.open file_path, "r"

          [:ok, upload(url, headers, file)]
        rescue Net::HTTPClientException, Net::HTTPFatalError, Net::OpenTimeout, SocketError => err # TODO handle File errors, JSON parse errors
          [:error, err.message]
        end

        private

        def upload(url, headers, file)
          headers = headers.merge "Content-Length" => file.size.to_s,
                                  "Transfer-Encoding" => "chunked"

          response = HTTParty.put url,
                                  headers: headers,
                                  body_stream: file

          response.success? ? JSON.parse(response.body) : response.error!
        end
      end
    end
  end
end
