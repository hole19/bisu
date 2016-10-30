describe Bisu::Config do
  subject(:config) { Bisu::Config.new(hash: hash) }

  let(:hash) { {
    type: "BisuOS",
    dictionary: {
      sheet_id:    "abc1234567890",
      keys_column: "key_name"
    },
    translate: [
      { in:        "path/to/file/to/1.ext.translatable",
        out:       "path/to/final-%{locale}/1.ext",
        out_en_us: "path/to/default/1.ext"
      },
      { in:        "path/to/file/to/2.ext.translatable",
        out:       "path/to/final-%{locale}/2.ext",
        out_en_us: "path/to/default/2.ext"
      },
    ],
    languages: [
      { locale: "en-US",      language: "english"    },
      { locale: "pt",         language: "portuguese" },
      { locale: "pt-PT",      language: "portuguese" },
      { locale: "pt-Batatas", language: "portuguese" }
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
        ["path/to/file/to/1.ext.translatable", "path/to/default/1.ext",          "english",    "en-US"     ],
        ["path/to/file/to/1.ext.translatable", "path/to/final-pt/1.ext",         "portuguese", "pt"        ],
        ["path/to/file/to/1.ext.translatable", "path/to/final-pt-PT/1.ext",      "portuguese", "pt-PT"     ],
        ["path/to/file/to/1.ext.translatable", "path/to/final-pt-Batatas/1.ext", "portuguese", "pt-Batatas"],
        ["path/to/file/to/2.ext.translatable", "path/to/default/2.ext",          "english",    "en-US"     ],
        ["path/to/file/to/2.ext.translatable", "path/to/final-pt/2.ext",         "portuguese", "pt"        ],
        ["path/to/file/to/2.ext.translatable", "path/to/final-pt-PT/2.ext",      "portuguese", "pt-PT"     ],
        ["path/to/file/to/2.ext.translatable", "path/to/final-pt-Batatas/2.ext", "portuguese", "pt-Batatas"]
      )
    end
  end
end
