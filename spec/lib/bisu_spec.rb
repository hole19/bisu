describe Bisu do
  subject(:run) { Bisu.run([]) }

  let(:translatable) { nil }

  before do
    if translatable
      file = File.open(translatable)
      allow(Bisu).to receive(:open_file).and_return(file)
      allow_any_instance_of(Bisu::GoogleSheet).to receive(:to_hash).and_return({
        "kKey" => { "english" => "Value" }
      })
      allow(Bisu).to receive(:localize_file)
    end
  end

  shared_examples_for "a good translation" do
    it { expect { run }.not_to raise_error }

    it "logs an error" do
      expect {
        run
      }.to not_change { Bisu::Logger.summary[:warn] }
       .and not_change { Bisu::Logger.summary[:error] }
    end
  end

  def expect_loc(locale, language, default_language, in_path, out_path)
    expect(Bisu).to receive(:localize_file).with(any_args, locale, language, default_language, in_path, out_path)
  end

  context "when using ios.translatable.yml" do
    let(:translatable) { "spec/fixtures/ios.translatable.yml" }

    it_behaves_like "a good translation"

    it "localizes the right files in the right languages" do
      expect_loc("en",    "english", nil, "hole19/Localizable.strings.translatable", "hole19/en.lproj/Localizable.strings")
      expect_loc("en-US", "english", nil, "hole19/Localizable.strings.translatable", "hole19/en-US.lproj/Localizable.strings")
      expect_loc("en",    "english", nil, "hole19/Countries.strings.translatable",   "hole19/en.lproj/Countries.strings")
      expect_loc("en-US", "english", nil, "hole19/Countries.strings.translatable",   "hole19/en-US.lproj/Countries.strings")
      run
    end
  end

  context "when using android.translatable.yml" do
    let(:translatable) { "spec/fixtures/android.translatable.yml" }

    it_behaves_like "a good translation"

    it "localizes the right files in the right languages" do
      expect_loc("en",    "english", nil, "app/src/main/values-translatable/strings.xml.translatable",                "app/src/main/res/values/strings.xml")
      expect_loc("en-US", "english", nil, "app/src/main/values-translatable/strings.xml.translatable",                "app/src/main/res/values-en-rUS/strings.xml")
      expect_loc("en",    "english", nil, "app/src/main/values-translatable/strings-authentication.xml.translatable", "app/src/main/res/values/strings-authentication.xml")
      expect_loc("en-US", "english", nil, "app/src/main/values-translatable/strings-authentication.xml.translatable", "app/src/main/res/values-en-rUS/strings-authentication.xml")
      run
    end
  end

  context "when using ror.translatable.yml" do
    let(:translatable) { "spec/fixtures/ror.translatable.yml" }

    it_behaves_like "a good translation"

    it "localizes the right files in the right languages" do
      expect_loc("en",    "english", nil, "config/locales/yml.translatable",           "config/locales/en.yml")
      expect_loc("en-US", "english", nil, "config/locales/yml.translatable",           "config/locales/en-US.yml")
      expect_loc("en",    "english", nil, "config/locales/countries.yml.translatable", "config/locales/en.countries.yml")
      expect_loc("en-US", "english", nil, "config/locales/countries.yml.translatable", "config/locales/en-US.countries.yml")
      run
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
