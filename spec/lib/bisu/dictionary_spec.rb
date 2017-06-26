describe Bisu::Dictionary do
  subject(:dict) { Bisu::Dictionary.new(keys) }

  describe ".initialize" do
    let(:keys) { { "lang" => { "kNo1" => "text" } } }
    it { expect { subject }.not_to raise_error }

    context "when created with invalid type parameters" do
      let(:keys) { "cenas" }
      it { expect { subject }.to raise_error /expected Hash/ }
    end

    context "when created with an invalid json schema" do
      let(:keys) { { "lang" => "text" } }
      it { expect { subject }.to raise_error /lang.+expected Hash/ }
    end

    context "when created with an invalid json schema" do
      let(:keys) { { "a-lang" => { "kNo1" => { "wtvr" => "text" } } } }
      it { expect { subject }.to raise_error /a-lang.+kNo1.+expected String/ }
    end

    context "when given empty translations" do
      let(:keys) { { "lang" => { "kNo1" => nil } } }
      it { expect { subject }.not_to raise_error }
    end
  end

  describe "#has_language?" do
    let(:keys) { {
      "lang1" => { "kNo1" => "no1-lang1" },
      "lang2" => { "kNo1" => "no1-lang2", "kNo2" => "no1-lang2" },
      "lang3" => { "kNo2" => "no2-lang3" }
    } }

    it "returns true if that language is translated" do
      expect(dict.has_language?("lang2")).to be true
    end

    it "returns true if that language is only partially translated" do
      expect(dict.has_language?("lang3")).to be true
    end

    it "returns false if that language does not exist in any key" do
      expect(dict.has_language?("lang-no-available")).to be false
    end

    it "returns true if that language is in another case" do
      expect(dict.has_language?("Lang2")).to be true
    end
  end

  describe "#localize" do
    let(:keys) { {
      "english"    => { "kCray" => "You are crazy!" },
      "portuguese" => { "kCray" => "Estás maluco!" },
      "kriolo"     => { "kCray" => "Bo sta crazy!" }
    } }

    it "localizes a key" do
      expect(dict.localize("kriolo", "kCray")).to eq "Bo sta crazy!"
    end

    it "returns nil when the key does not exist" do
      expect(dict.localize("kriolo", "kDoesntExist")).to be nil
    end

    it "returns nil when language is not available" do
      expect(dict.localize("finish", "kCray")).to be nil
    end

    it "localizes a key when the language is in another case" do
      expect(dict.localize("krioLo", "kCray")).to eq "Bo sta crazy!"
    end
  end
end
