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
        %i[prerelease_specs_url specs_url]
          .flat_map { |getter| fetch repo.public_send(getter), repo.headers }
          .sort
          .then { |specs| Specs.filter specs, only: only }
      end

      private_class_method

      def fetch(url, headers)
        Specs.new(url: url, headers: headers)
             .specs
      rescue Zlib::GzipFile::Error, Net::HTTPClientException, Net::HTTPFatalError, Net::OpenTimeout, SocketError => err
        raise ClientError, "Could not fetch specs. URL: #{url}, Reason: #{err.message}"
      end
    end
  end
end
