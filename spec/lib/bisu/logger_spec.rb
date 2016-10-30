describe Bisu::Logger do
  let(:summary) { Bisu::Logger.summary }
  let(:info)    { summary[:info] }
  let(:warn)    { summary[:warn] }
  let(:error)   { summary[:error] }

  context "when logging to info" do
    before { Bisu::Logger.info "msg" }

    it "returns the expected totals" do
      expect(info).to  eq 1
      expect(warn).to  eq 0
      expect(error).to eq 0
    end
  end

  context "when logging to warn" do
    before { Bisu::Logger.warn "msg" }

    it "returns the expected totals" do
      expect(info).to  eq 0
      expect(warn).to  eq 1
      expect(error).to eq 0
    end
  end

  context "when logging to error" do
    before { Bisu::Logger.error "msg" }

    it "returns the expected totals" do
      expect(info).to  eq 0
      expect(warn).to  eq 0
      expect(error).to eq 1
    end
  end
end
