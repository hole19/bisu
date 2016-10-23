describe Bisu::Dictionary do
  subject(:dict) { Bisu::Dictionary.new(keys) }

  describe ".initialize" do
    let(:keys) { { "kNo1" => { "lang" => "text" } } }
    it { expect { subject }.not_to raise_error }

    context "when created with invalid type parameters" do
      let(:keys) { "cenas" }
      it { expect { subject }.to raise_error /expected Hash$/ }
    end

    context "when created with an invalid json schema" do
      let(:keys) { { "kNo1" => "text" } }
      it { expect { subject }.to raise_error /kNo1.+expected Hash/ }
    end

    context "when created with an invalid json schema" do
      let(:keys) { { "kNo1" => { "a-lang" => { "wtvr" => "text" } } } }
      it { expect { subject }.to raise_error /kNo1.+a-lang.+expected String/ }
    end

    context "when given empty translations" do
      let(:keys) { { "kNo1" => { "lang" => nil } } }
      it { expect { subject }.not_to raise_error }
    end
  end

  describe "#has_language?" do
    let(:keys) { {
      "kNo1" => { "lang1" => "no1-lang1", "lang2" => "no1-lang2" },
      "kNo2" => { "lang2" => "no2-lang2", "lang3" => "no2-lang3" }
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
  end

  describe "#localize" do
    let(:keys) { {
      "kCray" => {
        "english" => "You are crazy!",
        "portuguese" => "Estás maluco!",
        "kriolo" => "Bo sta crazy!"
      }
    } }

    it "localizes a key" do
      expect(dict.localize("kCray", "kriolo")).to eq "Bo sta crazy!"
    end

    it "returns nil when the key does not exist" do
      expect(dict.localize("kDoesntExist", "kriolo")).to be nil
    end

    it "returns nil when language is not available" do
      expect(dict.localize("kCray", "finish")).to be nil
    end
  end
end
