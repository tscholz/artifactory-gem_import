require "thor"

module Artifactory
  module GemImport
    class Cli < Thor
      check_unknown_options!

      def self.exit_on_failure?
        true
      end

      option :source_repo, required: true, type: :string

      option :target_repo, required: true, type: :string

      option :target_repo_access_token, required: true, type: :string

      option :only, type: :string, default: ".+"

      option :force, type: :boolean, default: false

      desc "import", "Copy gems from the source repo into the target repo."

      def import
        say GemImport.import! source_repo: source_repo,
                              target_repo: target_repo,
                              only: options[:only],
                              force: options[:force]
      end

      option :target_repo, required: true, type: :string

      option :target_repo_access_token, required: true, type: :string

      option :only, type: :string, default: ".+"

      desc "delete", "Delete gems from the target repo."

      def delete
        say GemImport.delete! repo: target_repo,
                              only: options[:only]
      end

      option :source_repo, required: true, type: :string

      option :target_repo, required: true, type: :string

      option :target_repo_access_token, required: true, type: :string

      option :only, type: :string, default: ".+"

      desc "show-missing", "Show gems not already in the target repo."

      def show_missing
        gems = GemImport.show_missing source_repo: source_repo,
                                      target_repo: target_repo,
                                      only: options[:only]

        gems.each { |gem| say gem }

        say gems.count
      end

      # option :target_repo, required: true, type: :string
      #
      # option :target_repo_access_token, required: true, type: :string
      #
      # desc "reindex", "Trigger reindexing of the target repo (Artifactory only)."
      # def reindex
      #   GemImport.reindex! repo: target_repo
      # end

      desc "version", "Show version information"

      def version
        say Artifactory::GemImport::VERSION
      end

      private

      def source_repo
        GemImport.source_repo url: options[:source_repo]
      end

      def target_repo
        GemImport.target_repo url: options[:target_repo],
                              access_token: options[:target_repo_access_token]
      end
    end
  end
end
