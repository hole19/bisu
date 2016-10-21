describe Bisu::KnowledgeBase do
  subject(:kb) { Bisu::KnowledgeBase.new(params) }

  let(:params) {
    {
      languages: ["english", "portuguese", "kriolo"],
      keys: {
        "kYouAreCrazy" => {
          "english" => "You are crazy!",
          "portuguese" => "Estás maluco!",
          "kriolo" => "Bo sta crazy!"
        }
      }
    }
  }

  describe "#has_language?" do
    subject { kb.has_language?(language) }

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
    subject { kb.localize(key, language) }
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

  context "when missing languages" do
    before { params.delete(:languages) }
    it do
      expect { subject }.to raise_error /expected :languages/
    end
  end

  context "when missing keys" do
    before { params.delete(:keys) }
    it do
      expect { subject }.to raise_error /expected :keys/
    end
  end

  context "when created with invalid type parameters" do
    let(:params) { "cenas" }
    it do
      expect { subject }.to raise_error /expected Hash/
    end
  end
end
