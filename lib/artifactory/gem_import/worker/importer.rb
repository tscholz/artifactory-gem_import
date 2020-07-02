require "tmpdir"
require "fileutils"

module Artifactory
  module GemImport
    module Worker
      class Importer < Base
        attr_reader :source_repo, :target_repo, :only

        def initialize(source_repo:, target_repo:, only: /.+/)
          @source_repo = source_repo
          @target_repo = target_repo
          @only = only
        end

        def import!
          output_counts

          missing_gems
            .map { |spec| Gem.new spec: spec, source_repo: source_repo, target_repo: target_repo, cache_dir: tmp_dir }
            .each { |gem| process gem }

          summary
        ensure
          remove_tmp_dir!
        end

        private

        def output_counts
          publisher.tell ["Source Repo (#{source_repo.url})", :count, GemSpecs.get(repo: source_repo, only: only).count]
          publisher.tell ["Target Repo (#{target_repo.url})", :count, GemSpecs.get(repo: target_repo, only: only).count]
          publisher.tell ["Missing in target repo", :count, missing_gems.count]
        end

        def process(gem)
          publisher.tell [gem, :processing]

          download(gem) and upload(gem) and verify(gem)

          cleanup(gem) if gem.errors.on(:verify).any?
        end

        def missing_gems
          @missing_gems ||= GemSpecs.missing_gems source_repo: source_repo,
                                                  target_repo: target_repo,
                                                  only: only
        end

        def download(gem)
          publisher.tell [gem, :downloading]

          status, msg = downloader.call gem.source_url,
                                        gem.cache_path

          if status == :ok
            bookkeeper.tell [gem, :downloaded, 1]
          else
            gem.errors.add :downlod, msg
            bookkeeper.tell [gem, :download_failed, 1]
          end

          publisher.tell [gem, :status, status]

          status == :ok
        end

        def upload(gem)
          publisher.tell [gem, :uploading]

          status, msg = uploader.call gem.target_url,
                                      gem.target_headers,
                                      gem.cache_path

          if status == :ok
            gem.foreign_representation = msg
            bookkeeper.tell [gem, :uploaded, 1]
          else
            gem.errors.add :upload, msg
            bookkeeper.tell [gem, :upload_failed, 1]
          end

          publisher.tell [gem, :status, status]

          status == :ok
        end

        def verify(gem)
          publisher.tell [gem, :verifying]

          status, msg = verifier.call gem.cache_path,
                                      gem.foreign_representation

          if status == :ok
            bookkeeper.tell [gem, :verified, 1]
          else
            gem.errors.add :verify, msg
            reviewer.tell gem
            bookkeeper.tell [gem, :verification_failed, 1]
          end

          publisher.tell [gem, :status, status]

          status == :ok
        end

        def cleanup(gem)
          publisher.tell [gem, :cleaning]

          status, msg = cleaner.call gem.target_url,
                                     gem.target_headers

          if status == :ok
            bookkeeper.tell [gem, :cleaned, 1]
          else
            gem.errors.add :cleanup, msg
            reviewer.tell gem
            bookkeeper.tell [gem, :cleanup_failed, 1]
          end

          publisher.tell [gem, :status, status]

          status == :ok
        end

        def downloader
          @downloader ||= Gems.downloader
        end

        def uploader
          @uploader ||= Gems.uploader
        end

        def verifier
          @verifier ||= Gems.verifier
        end

        def cleaner
          @cleaner ||= Gems.cleaner
        end

        def remove_tmp_dir!
          FileUtils.remove_entry tmp_dir
        end

        def tmp_dir
          @tmp_dir ||= Dir.mktmpdir
        end
      end
    end
  end
end
