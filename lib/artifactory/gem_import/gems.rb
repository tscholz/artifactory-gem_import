require_relative "gems/cleaner"
require_relative "gems/downloader"
require_relative "gems/uploader"
require_relative "gems/verifier"

module Artifactory
  module GemImport
    module Gems
      module_function

      def downloader
        Downloader.new
      end

      def uploader
        Uploader.new
      end

      def verifier
        Verifier.new
      end

      def cleaner
        Cleaner.new
      end
    end
  end
end
