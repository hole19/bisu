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
      { locale: "pt-PT", kb_language: "portuguese" },
      { locale: "pt-BR", kb_language: "portuguese", path: "path/to/final-%{android_locale}/%{out_name}" },
    ]
  } }

  context "when hash is missing params" do
    before { hash.delete(:type) }
    it { expect { config }.to raise_error /missing keys/i }
  end

  its(:to_h)       { should eq(hash) }
  its(:type)       { should eq("BisuOS") }
  its(:dictionary) { should eq({ sheet_id: "abc1234567890", keys_column: "key_name" }) }

  describe "#localize_files" do
    it "yields 5 times with the expected arguments" do
      expect { |b|
        config.localize_files(&b)
      }.to yield_successive_args(
        ["path/to/file/to/1.ext.translatable", "path/to/default/1.ext",      "english",    "en"   ],
        ["path/to/file/to/1.ext.translatable", "path/to/final-pt/1.ext",     "portuguese", "pt"   ],
        ["path/to/file/to/1.ext.translatable", "path/to/final-pt-PT/1.ext",  "portuguese", "pt-PT"],
        ["path/to/file/to/1.ext.translatable", "path/to/final-pt-rBR/1.ext", "portuguese", "pt-BR"],
        ["path/to/file/to/2.ext.translatable", "path/to/default/2.ext",      "english",    "en"   ],
        ["path/to/file/to/2.ext.translatable", "path/to/final-pt/2.ext",     "portuguese", "pt"   ],
        ["path/to/file/to/2.ext.translatable", "path/to/final-pt-PT/2.ext",  "portuguese", "pt-PT"],
        ["path/to/file/to/2.ext.translatable", "path/to/final-pt-rBR/2.ext", "portuguese", "pt-BR"]
      )
    end
  end
end
