describe Bisu::Config do
  subject(:config) { Bisu::Config.new(hash: hash) }

  let(:hash) { {
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
  } }

  its(:to_h) { should eq(hash) }

  context "when hash is missing params" do
    before { hash.delete(:type) }
    it { expect { config }.to raise_error /missing keys/i }
  end
end
