module Artifactory
  module GemImport
    module Worker
      class Base

        private

        def summary
          summary = bookkeeper.ask!(:summary)
          for_review = reviewer.ask!(:summary)

          for_review.any? ? summary.merge(review: for_review) : summary
        end

        def bookkeeper
          @bookkeeper ||= Bookkeeper.counter
        end

        def publisher
          @publisher ||= Bookkeeper.publisher
        end

        def reviewer
          @reviewer ||= Bookkeeper.reviewer
        end
      end
    end
  end
end