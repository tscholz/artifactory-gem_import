module Artifactory
  module GemImport
    class Gem
      class Errors
        def initialize
          @errors = Hash.new { |h, k| h[k] = [] }
        end

        def add(key, msg)
          @errors[key] << msg
          self
        end

        def any?
          @errors.values.flatten.any?
        end

        def on(key)
          @errors[key]
        end

        def full_messages
          @errors
            .keys
            .map { |key| [key, full_message(key)].join(": ") }
            .join("; ")
        end

        def full_message(key)
          @errors[key].join(", ")
        end
      end
    end
  end
end
