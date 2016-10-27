describe Bisu::Config do
  subject(:config) { Bisu::Config.new(hash: hash) }

  context "given an hash" do
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

    context "when missing mandatory keys" do
      let(:hash) { {} }
      it { expect { config }.to raise_error /missing keys: type, sheet_id, keys_column, in, out_path, out/i }
    end

    context "when some String key has an invalid type" do
      before { hash[:type] = {} }
      it { expect { config }.to raise_error /expected string, got hash/i }
    end

    context "when the child of some Array key is invalid" do
      before { hash[:in] = [{}] }
      it { expect { config }.to raise_error /expected string, got hash/i }
    end

    context "when the child of some Hash key is invalid" do
      before { hash[:out] = [{}] }
      it { expect { config }.to raise_error /missing keys: locale, kb_language/i }
    end
  end

  context "given something other then an Hash" do
    let(:hash) { nil }
    it { expect { config }.to raise_error /expected hash/i }
  end
end
