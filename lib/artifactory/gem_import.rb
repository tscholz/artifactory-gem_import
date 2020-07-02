require_relative "gem_import/bookkeeper"
require_relative "gem_import/gem"
require_relative "gem_import/gems"
require_relative "gem_import/gem_specs"
require_relative "gem_import/repo"
require_relative "gem_import/version"
require_relative "gem_import/worker"

module Artifactory
  module GemImport
    Error = Class.new StandardError
    ClientError = Class.new Error

    module_function

    def import!(source_repo:, target_repo:, only: /.+/)
      Worker::Importer
        .new(source_repo: source_repo, target_repo: target_repo, only: only)
        .import!
    end

    def show_missing(source_repo:, target_repo:, only: /.+/)
      Worker::MissingDetector
        .new(source_repo: source_repo, target_repo: target_repo, only: only)
        .detect!
    end

    def delete!(repo:, only: /.+/)
      Worker::Remover
        .new(target_repo: repo, only: only)
        .remove!
    end

    def source_repo(url:)
      Repo.new url: url,
               headers: {}
    end

    def target_repo(url:, api_key:)
      Repo.new url: url,
               headers: { "X-JFrog-Art-Api" => api_key }
    end
  end
end
