module Artifactory
  module GemImport
    module Bookkeeper
      class Base
        def initialize
          init_store
        end

        def tell(message)
          on_message message
        end

        alias_method :ask!, :tell

        private

        def init_store
          raise NotImplementedError
        end

        def on_message(message)
          raise NotImplementedError
        end
      end
    end
  end
end
