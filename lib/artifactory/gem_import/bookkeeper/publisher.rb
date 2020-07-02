module Artifactory
  module GemImport
    module Bookkeeper
      class Publisher < Base
        private

        # Maintain the contract
        def init_store
        end

        def on_message(message)
          subject, action, msg = message

          case action
          when :processing
            puts "Processing #{subject.name} (#{subject.version})"
          when :status
            if msg == :ok
              puts msg
            else
              puts [msg, subject.errors.full_messages].join("\t")
            end
          when :count
            puts "#{subject}: #{msg} gems"
          else
            print "   --> #{action.to_s.capitalize}".ljust(20)
          end
        end
      end
    end
  end
end
