module Artifactory
  module GemImport
    module Worker
      class Remover < Base
        # This gem is required to let the Artifactory Gem Server work properly.
        NEVER_DELETE = %w(rubygems-update).freeze

        attr_reader :target_repo, :only

        def initialize(target_repo:, only: /.+/)
          @target_repo = target_repo
          @only = only
        end

        def remove!
          gems.each &method(:process)

          summary
        end

        private

        def process(gem)
          publisher.tell [gem, :processing, gem.filename]

          required_gem?(gem) ? skip(gem) : remove(gem)
        end

        def remove(gem)
          publisher.tell [gem, :removing]

          status, msg = cleaner.call gem.target_url,
                                     gem.target_headers

          if status == :ok
            bookkeeper.tell [gem, :removed, 1]
          else
            gem.errors.add :removal, msg
            reviewer.tell gem
            bookkeeper.tell [gem, :removal_failed, 1]
          end

          publisher.tell [gem, :status, status]

          status == :ok
        end

        def skip(gem)
          publisher.tell [gem, :skipping]

          # Nothing to do
          bookkeeper.tell [gem, :skipped, 1]

          publisher.tell [gem, :status, :ok]

          true
        end

        def required_gem?(gem)
          NEVER_DELETE.include? gem.name
        end

        def gems
          @gems ||=
            GemSpecs
              .get(repo: target_repo, only: only)
              .map { |spec| Gem.new spec: spec, source_repo: nil, target_repo: target_repo, cache_dir: nil }
        end

        def cleaner
          @cleaner ||= Gems.cleaner
        end
      end
    end
  end
end
