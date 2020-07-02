RSpec.describe Artifactory::GemImport::GemSpecs::Parser do
  describe "#call" do
    let(:specs_data) { File.read "spec/fixtures/specs.4.8.gz" }

    let(:gem_examples) do
      [
        ["example", Gem::Version.new("0.0.1"), "ruby"],
        ["example", Gem::Version.new("0.0.2"), "ruby"],
        ["example", Gem::Version.new("0.0.2"), "java"],
        ["other-example", Gem::Version.new("0.1.0"), "ruby"],
      ]
    end

    it "inflates and marshals a given gem specs zip" do
      expect(described_class.call specs_data).to contain_exactly *gem_examples
    end
  end
end
