require "zlib"
require "stringio"

module Artifactory
  module GemImport
    module GemSpecs
      class Parser
        def self.call(data)
          new(data).call
        end

        def initialize(data)
          @io = StringIO.new data
        end

        def call
          Marshal.load inflated_data
        end

        private

        def inflated_data
          Zlib::GzipReader.new @io
        end
      end
    end
  end
end
