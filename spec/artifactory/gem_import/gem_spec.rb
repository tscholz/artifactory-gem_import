module Artifactory
  RSpec.describe GemImport::Gem do
    let(:gem) do
      described_class.new spec: ["my-gem", instance_double(::Gem::Version, to_s: "0.1.0"), "ruby"],
                          source_repo: source_repo,
                          target_repo: target_repo,
                          cache_dir: "/tmp/my-cache-dir"
    end

    let(:source_repo) { GemImport.source_repo(url: "http://source-repo.local") }

    let(:target_repo) { GemImport.target_repo(url: "http://target-repo.local", access_token: "XYZ") }

    describe "#filename" do
      it { expect(gem.filename).to eq "my-gem-0.1.0.gem" }
    end

    describe "#source_url" do
      it { expect(gem.source_url).to eq "http://source-repo.local/gems/my-gem-0.1.0.gem" }
    end

    describe "#source_gems_url" do
      it { expect(gem.source_gems_url).to eq "http://source-repo.local/gems/" }
    end

    describe "#target_url" do
      it { expect(gem.target_url).to eq "http://target-repo.local/gems/my-gem-0.1.0.gem" }
    end

    describe "#target_gems_url" do
      it { expect(gem.target_gems_url).to eq "http://target-repo.local/gems/" }
    end

    describe "#cache_path" do
      it { expect(gem.cache_path).to eq "/tmp/my-cache-dir/my-gem-0.1.0.gem" }
    end
  end
end
