require "digest"

module Artifactory
  module GemImport
    module Gems
      class Verifier
        def call(cache_path, foreign_representation)
          md5, foreign_md5 = calculate_checksums File.open(cache_path, "r"),
                                                 foreign_representation

          md5 == foreign_md5 ? [:ok] :
            [:failed, "Checksum comparison for uploaded gem #{File.basename cache_path} failed. Expected #{md5}, got #{foreign_md5}"]
        end

        private

        def calculate_checksums(file, foreign_representation)
          [Digest::MD5.hexdigest(file.read), foreign_representation.dig("checksums", "md5")]
        end
      end
    end
  end
end
