describe Bisu::Config do
  subject(:config) { Bisu::Config.new(hash: hash) }

  let(:hash) { {
    type: "BisuOS",
    dictionary: {
      type: "google_sheet",
      url: "https://abc1234567890",
      keys_column: "key name",
    },
    translate: [
      { in: "path/to/file/to/1.ext.translatable",
        out: "path/to/final-%{locale}/1.ext",
        out_en_us: "path/to/default/1.ext"
      },
      { in: "path/to/file/to/2.ext.translatable",
        out: "path/to/final-%{locale}/2.ext",
        out_en_us: "path/to/default/2.ext"
      },
    ],
    languages: [
      { locale: "en-US", language: "english"    },
      { locale: "pt", language: "portuguese" },
      { locale: "pt-PT", language: "portuguese" },
      { locale: "pt-Batatas", language: "portuguese-bt", fallback_language: "portuguese" }
    ]
  } }

  context "when hash is missing params" do
    before { hash.delete(:type) }
    it { expect { config }.to raise_error /missing keys/i }
  end

  its(:to_h) { should eq(hash) }
  its(:type) { should eq("BisuOS") }

  describe "#dictionary" do
    subject(:dictionary) { config.dictionary }

    it { should eq({ type: "google_sheet", url: "https://abc1234567890", keys_column: "key name" }) }

    context "when given a OneSky type dictionary" do
      before do
        hash[:dictionary] = {
          type: "one_sky",
          api_key: "as387oavh48",
          api_secret: "bp0s5avo8a59",
          project_id: 328742,
          file_name: "file.json"
        }
      end

      it { should eq({ type: "one_sky", api_key: "as387oavh48", api_secret: "bp0s5avo8a59", project_id: 328742, file_name: "file.json" }) }
    end

    context "when given a Url type dictionary" do
      before do
        hash[:dictionary] = {
          type: "url",
          url: "a_url"
        }
      end

      it { should eq({ type: "url", url: "a_url" }) }
    end

    context "when given an unknown type dictionary" do
      before { hash[:dictionary] = { type: "i_dunno" } }
      it { expect { config }.to raise_error /unknown dictionary type 'i_dunno'/i }
    end
  end

  describe "#localize_files" do
    it "yields 5 times with the expected arguments" do
      expect { |b|
        config.localize_files(&b)
      }.to yield_successive_args(
        ["path/to/file/to/1.ext.translatable", "path/to/default/1.ext",          "en-US",      "english",       nil         ],
        ["path/to/file/to/1.ext.translatable", "path/to/final-pt/1.ext",         "pt",         "portuguese",    nil         ],
        ["path/to/file/to/1.ext.translatable", "path/to/final-pt-PT/1.ext",      "pt-PT",      "portuguese",    nil         ],
        ["path/to/file/to/1.ext.translatable", "path/to/final-pt-Batatas/1.ext", "pt-Batatas", "portuguese-bt", "portuguese"],
        ["path/to/file/to/2.ext.translatable", "path/to/default/2.ext",          "en-US",      "english",       nil         ],
        ["path/to/file/to/2.ext.translatable", "path/to/final-pt/2.ext",         "pt",         "portuguese",    nil         ],
        ["path/to/file/to/2.ext.translatable", "path/to/final-pt-PT/2.ext",      "pt-PT",      "portuguese",    nil         ],
        ["path/to/file/to/2.ext.translatable", "path/to/final-pt-Batatas/2.ext", "pt-Batatas", "portuguese-bt", "portuguese"]
      )
    end
  end
end
