module Artifactory
  module GemImport
    module Bookkeeper
      class Reviewer < Base
        private

        def init_store
          @store = []
        end

        def on_message(message)
          subject, _action, _msg = message

          case subject
          when :summary
            @store
              .map(&:filename)
              .uniq
              .sort
          else
            @store << subject
          end
        end
      end
    end
  end
end
