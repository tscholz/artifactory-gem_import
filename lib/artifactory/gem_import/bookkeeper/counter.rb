module Artifactory
  module GemImport
    module Bookkeeper
      class Counter < Base
        private

        def init_store
          @store = Hash.new do |store, action|
            store[action] = 0
          end
        end

        def on_message(message)
          subject, action, count = message

          case subject
          when :summary
            @store.dup
          when :reset
            init_store
          else
            @store[action] += count
            self
          end
        end
      end
    end
  end
end
