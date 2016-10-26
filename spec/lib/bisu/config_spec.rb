describe Bisu::Config do
  subject(:config) { Bisu::Config.new(file: file) }

  context "given a yml file" do
    let(:file) { File.open("spec/fixtures/sample_translatable.yml") }

    it "should parse the yml with deep key symbolization" do
      expect(config.to_h).to eq({
        type:        "BisuOS",
        sheet_id:    "abc1234567890",
        keys_column: "key_name",
        in:          [
          "path/to/file/to/1.ext.translatable",
          "path/to/file/to/2.ext.translatable"
        ],
        out_path:    "path/to/final-%{locale}/%{out_name}",
        out:         [
          { locale: "en",    kb_language: "english", path: "path/to/default/%{out_name}" },
          { locale: "pt",    kb_language: "portuguese" },
          { locale: "pt-PT", kb_language: "portuguese" }
        ]
      })
    end
  end

  context "given something other then a file" do
    let(:file) { nil }
    it { expect { config }.to raise_error /expected File/ }
  end
end
