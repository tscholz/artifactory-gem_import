require_relative "gem_specs/downloader"
require_relative "gem_specs/parser"
require_relative "gem_specs/specs"

module Artifactory
  module GemImport
    module GemSpecs
      module_function

      def missing_gems(source_repo:, target_repo:, only: /.+/)
        source_specs = get repo: source_repo, only: only
        target_specs = get repo: target_repo, only: only

        source_specs - target_specs
      end

      def get(repo:, only: /.+/)
        specs = Specs
          .new(url: repo.specs_url, headers: repo.headers)
          .specs
      rescue Net::HTTPClientException, Net::HTTPFatalError, Net::OpenTimeout, SocketError => err
        raise ClientError, "Could not fetch specs. URL: #{repo.specs_url}, Reason: #{err.message}"
      else
        Specs.filter(specs, only: only).sort
      end
    end
  end
end
