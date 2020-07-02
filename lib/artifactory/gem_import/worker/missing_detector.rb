module Artifactory
  module GemImport
    module Worker
      class MissingDetector < Base
        attr_reader :source_repo, :target_repo, :only

        def initialize(source_repo:, target_repo:, only: /.+/)
          @source_repo = source_repo
          @target_repo = target_repo
          @only = only
        end

        def detect!
          missing_gems
            .map { |spec| Gem.new spec: spec, source_repo: nil, target_repo: nil, cache_dir: nil }
            .map(&:filename)
        end

        private

        def missing_gems
          @missing_gems ||= GemSpecs.missing_gems source_repo: source_repo,
                                                  target_repo: target_repo,
                                                  only: only
        end
      end
    end
  end
end
