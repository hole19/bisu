describe Bisu do
  subject(:run) { Bisu.run([]) }

  context "when there is a translatable.yml" do
    let(:file) { File.open("spec/fixtures/sample.translatable.yml") }

    before do
      allow(Bisu).to receive(:open_file).and_return(file)
      allow_any_instance_of(Bisu::Source::GoogleSheet).to receive(:to_i18).and_return({
        "english" => { "kKey" => "Value" }
      })
      allow(Bisu).to receive(:localize_file)
    end

    it { expect { run }.not_to raise_error }

    it "logs an error" do
      expect {
        run
      }.to not_change { Bisu::Logger.summary[:warn] }
       .and not_change { Bisu::Logger.summary[:error] }
    end
  end

  context "when translatable.yml does not exist locally" do
    it { expect { run }.not_to raise_error }

    it "logs an error" do
      expect {
        run
      }.to not_change { Bisu::Logger.summary[:warn] }
       .and change { Bisu::Logger.summary[:error] }.by(1)
    end
  end
end
