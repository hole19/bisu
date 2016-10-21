describe Bisu::Dictionary do
  subject(:dict) { Bisu::Dictionary.new(keys) }

  let(:keys) { {
    "kYouAreCrazy" => {
      "english" => "You are crazy!",
      "portuguese" => "Estás maluco!",
      "kriolo" => "Bo sta crazy!"
    }
  } }

  describe "#has_language?" do
    subject { dict.has_language?(language) }

    context "when language is not available" do
      let(:language) { "kriolo" }
      it { should be true }
    end

    context "when language is not available" do
      let(:language) { "finish" }
      it { should be false }
    end
  end

  describe "#localize" do
    subject { dict.localize(key, language) }
    let(:key) { "kYouAreCrazy" }
    let(:language) { "kriolo" }

    it { should eq "Bo sta crazy!" }

    context "when key does not exist" do
      let(:key) { "kDoesntExist" }
      it { should be nil }
    end

    context "when language is not available" do
      let(:language) { "finish" }
      it { should be nil }
    end
  end

  context "when created with invalid type parameters" do
    let(:keys) { "cenas" }
    it do
      expect { subject }.to raise_error /expected Hash$/
    end
  end

  context "when created with an invalid json schema" do
    let(:keys) { { "kYouAreCrazy" => "Text" } }

    it do
      expect { subject }.to raise_error /expected Hash value for key/
    end
  end

  context "when created with an invalid json schema" do
    let(:keys) { { "kYouAreCrazy" => { "portuguese" => { "wtvr" => "Text" } } } }

    it do
      expect { subject }.to raise_error /expected String value for key/
    end
  end
end
