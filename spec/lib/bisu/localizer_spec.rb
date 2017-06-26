describe Bisu::Localizer do
  let(:language) { "Portuguese" }
  let(:locale)   { "pt-PT" }

  let(:keys) { {
    language => {
      "kTranslationKey"  => "Não sabes nada João das Neves",
      "kTranslationKey2" => "Naaada!",
      "k1ParameterKey"   => "Não sabes nada %{name}",
      "k2ParametersKey"  => "Sabes %{perc} por cento %{name}",

      # type dependent translations
      "kDoubleQuoted"    => "Não sabes nada \"João das Neves\"",
      "kSingleQuoted"    => "Não sabes nada 'João das Neves'",
      "kEllipsis"        => "Não sabes nada João das Neves...",
      "kAmpersand"       => "Não sabes nada João das Neves & Pícaros",
      "kAtSign"          => "\@johnsnow sabes alguma coisa?"
    },
    "English" => {
      "kMissingTransKey" => "You know little John Snow"
    }
  } }

  let(:kb) { Bisu::Dictionary.new(keys) }
  let(:localizer) { Bisu::Localizer.new(kb, type) }

  shared_examples_for "a localizer" do
    it { expect { localizer }.not_to raise_error }

    def translates(text, fallback: nil, to:, lang: nil)
      translation = localizer.localize(text, lang || language, locale, fallback)
      expect(translation).to eq to
    end

    it { translates("a line with no key", to: "a line with no key") }

    it { translates("this special key: $specialKComment1$", to: "this special key: This file was automatically generated based on a translation template.") }
    it { translates("this special key: $specialKComment2$", to: "this special key: Remember to CHANGE THE TEMPLATE and not this file!") }
    it { translates("this special key: $specialKLanguage$", to: "this special key: #{language}") }
    it { translates("this special key: $specialKLocale$",   to: "this special key: #{locale}") }

    it { translates("this key: $kTranslationKey$", to: "this key: Não sabes nada João das Neves") }
    it { translates("this key: $kTranslationKey$", to: "this key: Não sabes nada João das Neves", lang: "portuguese") }
    it { translates("this unknown key: $kUnknownKey$", to: "this unknown key: $kUnknownKey$") }
    it { translates("this key with missing translations: $kMissingTransKey$", to: "this key with missing translations: $kMissingTransKey$") }
    it { translates("this key with missing translations: $kMissingTransKey$", fallback: "English", to: "this key with missing translations: You know little John Snow") }
    it { translates("these 2 keys: $kTranslationKey$, $kTranslationKey2$", to: "these 2 keys: Não sabes nada João das Neves, Naaada!") }

    it { translates("1 parameter: $k1ParameterKey$",                         to: "1 parameter: Não sabes nada %{name}") }
    it { translates("1 parameter: $k1ParameterKey{name:%1$s}$",              to: "1 parameter: Não sabes nada %1$s") }
    it { translates("2 parameters: $k2ParametersKey$",                       to: "2 parameters: Sabes %{perc} por cento %{name}") }
    it { translates("2 parameters: $k2ParametersKey{perc:%2$d, name:%1$s}$", to: "2 parameters: Sabes %2$d por cento %1$s") }
    it { translates("2 parameters: $k2ParametersKey{name:%1$s, perc:%2$d}$", to: "2 parameters: Sabes %2$d por cento %1$s") }

    # type dependent translations

    it { translates("$kDoubleQuoted$", to: expected[:double_quoted]) }
    it { translates("$kSingleQuoted$", to: expected[:single_quoted]) }
    it { translates("$kEllipsis$",     to: expected[:ellipsis]) }
    it { translates("$kAmpersand$",    to: expected[:ampersand]) }
    it { translates("$kAtSign$",       to: expected[:at_sign]) }

    # error handling

    it "throws a warnings when key has no translation" do
      expect {
        localizer.localize("$kUnknownKey$", language, locale)
      }.to change { Bisu::Logger.summary[:warn] }.by(1)
       .and not_change { Bisu::Logger.summary[:error] }
    end

    it "does not throw a warning when key is found" do
      expect {
        localizer.localize("$kTranslationKey$", language, locale)
      }.to not_change { Bisu::Logger.summary[:warn] }
       .and not_change { Bisu::Logger.summary[:error] }
    end

    it "throws an error when missing key parameters (expect on ruby on rails)" do
      if type == :ror
        expect {
          localizer.localize("$k1ParameterKey$", language, locale)
        }.to not_change { Bisu::Logger.summary[:warn] }
         .and not_change { Bisu::Logger.summary[:error] }
      else
        expect {
          localizer.localize("$k1ParameterKey$", language, locale)
        }.to not_change { Bisu::Logger.summary[:warn] }
         .and change { Bisu::Logger.summary[:error] }.by(1)
       end
    end

    it "does not throw an error when key parameters where given" do
      expect {
        localizer.localize("$k1ParameterKey{name:%1$s}$", language, locale)
      }.to not_change { Bisu::Logger.summary[:warn] }
       .and not_change { Bisu::Logger.summary[:error] }
    end

    it "throws an error when given parameters for parameterless key" do
      expect {
        localizer.localize("$kTranslationKey{param:%s}$", language, locale)
      }.to not_change { Bisu::Logger.summary[:warn] }
       .and change { Bisu::Logger.summary[:error] }.by(1)
    end
  end

  let(:type_dependent_defaults) { {
    double_quoted: keys[language]["kDoubleQuoted"],
    single_quoted: keys[language]["kSingleQuoted"],
    ellipsis:      keys[language]["kEllipsis"],
    ampersand:     keys[language]["kAmpersand"],
    at_sign:       keys[language]["kAtSign"]
  } }

  describe "of type iOS" do
    let(:type) { :ios }

    let(:expected) { type_dependent_defaults.merge(
      double_quoted: "Não sabes nada \\\"João das Neves\\\""
    ) }

    it_behaves_like "a localizer"
  end

  describe "of type Android" do
    let(:type) { :android }

    let(:expected) { type_dependent_defaults.merge(
      single_quoted: "Não sabes nada \\'João das Neves\\'",
      ellipsis: "Não sabes nada João das Neves…",
      ampersand: "Não sabes nada João das Neves &amp; Pícaros",
      at_sign: "\\@johnsnow sabes alguma coisa?"
    ) }

    it_behaves_like "a localizer"
  end

  describe "of type Ruby on Rails" do
    let(:type) { :ror }

    let(:expected) { type_dependent_defaults }

    it_behaves_like "a localizer"
  end

  describe "of an unkown type" do
    let(:type) { :dunno }
    it do
      expect { localizer }.to raise_error /Unknown type/
    end
  end
end
