require_relative "bookkeeper/base"
require_relative "bookkeeper/counter"
require_relative "bookkeeper/publisher"
require_relative "bookkeeper/reviewer"

module Artifactory
  module GemImport
    module Bookkeeper
      module_function

      def counter
        Counter.new
      end

      def publisher
        Publisher.new
      end

      def reviewer
        Reviewer.new
      end
    end
  end
end
