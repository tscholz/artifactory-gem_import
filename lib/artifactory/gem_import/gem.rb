require_relative "gem/errors"

module Artifactory
  module GemImport
    class Gem
      attr_reader :name, :version
      attr_reader :source_repo, :target_repo
      attr_reader :cache_dir
      attr_reader :errors

      attr_accessor :foreign_representation

      def initialize(spec:, source_repo:, target_repo:, cache_dir:)
        @name, @version, _lang = spec
        @cache_dir = cache_dir
        @source_repo = source_repo
        @target_repo = target_repo
        @errors = Errors.new
      end

      def source_url
        @source_url ||= File.join(source_repo.gems_url, filename)
      end

      def source_gems_url
        source_repo.gems_url
      end

      def source_headers
        source_repo.headers
      end

      def target_url
        @target_url ||= File.join(target_repo.gems_url, filename)
      end

      def target_gems_url
        target_repo.gems_url
      end

      def target_headers
        target_repo.headers
      end

      def cache_path
        @cache_path ||= File.join(cache_dir, filename)
      end

      def filename
        @filename ||= "#{name}-#{version}.gem"
      end
    end
  end
end
