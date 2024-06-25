require "digest"
require "json"

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
                                  "Transfer-Encoding" => "chunked",
                                  "X-Checksum-Sha1" => sha1(file),
                                  "X-Checksum-Md5" => md5(file)

          response = HTTParty.put url,
                                  headers: headers,
                                  body_stream: file

          response.success? ? JSON.parse(response.body) : response.error!
        end

        def sha1(file)
          Digest::SHA1.hexdigest(file.read).tap { file.rewind }
        end

        def md5(file)
          Digest::MD5.hexdigest(file.read).tap { file.rewind }
        end
      end
    end
  end
end
