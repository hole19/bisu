require 'minitest/autorun'
require 'bisu/translator'

class BisuTranslatorTest < Minitest::Test

  def setup
    @lang            = "portuguese"
    @incomplete_lang = "english"
    @locale          = "PT-PT"

    kb = Bisu::KnowledgeBase.new({
      languages: [@lang, @missing_lang],
      keys: {
        "kRegularKey1"    => { @lang => "Não sabes nada João das Neves", @incomplete_lang => "You know nothing John Snow" },
        "kRegularKey2"    => { @lang => "Não sabes isto João das Neves" },
        "kIOSKey"         => { @lang => "Não sabes nada \"João das Neves\"" },
        "kAndroidKey1"    => { @lang => "Não sabes nada 'João das Neves'" },
        "kAndroidKey2"    => { @lang => "Não sabes nada João das Neves..." },
        "kAndroidKey3"    => { @lang => "Não sabes nada João das Neves & Pícaros" },
        "k1ParameterKey"  => { @lang => "Não sabes nada %{name}" },
        "k2ParametersKey" => { @lang => "Sabes %{percentage} por cento %{name}." },
      }
    })

    @tios = Bisu::Translator.new(kb, :ios)
    @tand = Bisu::Translator.new(kb, :android)
    @tror = Bisu::Translator.new(kb, :ror)

    Bisu::Logger.silent_mode = true
  end

  def teardown
    Bisu::Logger.silent_mode = false
  end

  def test_simple_translate
    orig0 = "0: $kUnknownKey$"
    orig1 = "1: $specialKComment1$"
    orig2 = "2: $specialKComment2$"
    orig3 = "3: $specialKLanguage$"
    orig4 = "4: $specialKLocale$"
    orig5 = "5: $kRegularKey1$"
    orig6_1 = "6.1: $k1ParameterKey$"
    orig6_2 = "6.2: $k1ParameterKey{name:%1$s}$"
    orig7_1 = "7.1: $k2ParametersKey$"
    orig7_2 = "7.2: $k2ParametersKey{percentage:%2$d, name:%1$s}$"
    orig7_3 = "7.3: $k2ParametersKey{name:%1$s, percentage:%2$d}$"
    orig8_1 = "8.1: $kRegularKey1$"
    orig8_2 = "8.2: $kRegularKey2$"
    orig8_3 = "8.3: $kRegularKey2$"

    loc0 = "0: $kUnknownKey$"
    loc1 = "1: This file was automatically generated based on a translation template."
    loc2 = "2: Remember to CHANGE THE TEMPLATE and not this file!"
    loc3 = "3: #{@lang}"
    loc4 = "4: #{@locale}"
    loc5 = "5: Não sabes nada João das Neves"
    loc6_1 = "6.1: Não sabes nada %{name}"
    loc6_2 = "6.2: Não sabes nada %1$s"
    loc7_1 = "7.1: Sabes %{percentage} por cento %{name}."
    loc7_2 = "7.2: Sabes %2$d por cento %1$s."
    loc7_3 = "7.3: Sabes %2$d por cento %1$s."
    loc8_1 = "8.1: You know nothing John Snow"
    loc8_2 = "8.2: Não sabes isto João das Neves"
    loc8_3 = "8.3: $kRegularKey2$"

    [@tios, @tand, @tror].each do |translator|
      assert_equal translator.send(:localize, orig0,   @lang, @locale), loc0
      assert_equal translator.send(:localize, orig1,   @lang, @locale), loc1
      assert_equal translator.send(:localize, orig2,   @lang, @locale), loc2
      assert_equal translator.send(:localize, orig3,   @lang, @locale), loc3
      assert_equal translator.send(:localize, orig4,   @lang, @locale), loc4
      assert_equal translator.send(:localize, orig5,   @lang, @locale), loc5
      assert_equal translator.send(:localize, orig6_1, @lang, @locale), loc6_1
      assert_equal translator.send(:localize, orig6_2, @lang, @locale), loc6_2
      assert_equal translator.send(:localize, orig7_1, @lang, @locale), loc7_1
      assert_equal translator.send(:localize, orig7_2, @lang, @locale), loc7_2
      assert_equal translator.send(:localize, orig7_3, @lang, @locale), loc7_3

      assert_equal translator.send(:localize, orig8_1, @incomplete_lang, @locale, @lang), loc8_1
      assert_equal translator.send(:localize, orig8_2, @incomplete_lang, @locale, @lang), loc8_2
      assert_equal translator.send(:localize, orig8_3, @incomplete_lang, @locale       ), loc8_3
    end
  end

  def test_ios_translate
    assert_equal @tios.send(:localize, "1: $kIOSKey$", @lang, @locale), "1: Não sabes nada \\\"João das Neves\\\""
  end

  def test_android_translate
    assert_equal @tand.send(:localize, "1: $kAndroidKey1$", @lang, @locale), "1: Não sabes nada \\'João das Neves\\'"
    assert_equal @tand.send(:localize, "2: $kAndroidKey2$", @lang, @locale), "2: Não sabes nada João das Neves…"
    assert_equal @tand.send(:localize, "3: $kAndroidKey3$", @lang, @locale), "3: Não sabes nada João das Neves &amp; Pícaros"
  end
end
