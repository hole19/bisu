require 'minitest/autorun'
require 'bisu/translator'

class BisuTranslatorTest < Minitest::Test

  def setup
    @lang   = "portuguese"
    @locale = "portuguese"

    kb = Bisu::KnowledgeBase.new({
      languages: [@lang],
      keys: {
        "kRegularKey"  => { @lang => "Não sabes nada João das Neves" },
        "kIOSKey"      => { @lang => "Não sabes nada \"João das Neves\"" },
        "kAndroidKey1" => { @lang => "Não sabes nada 'João das Neves'" },
        "kAndroidKey2" => { @lang => "Não sabes nada João das Neves..." },
        "kAndroidKey3" => { @lang => "Não sabes nada João das Neves & Pícaros" },
      }
    })

    @tios = Bisu::Translator.new(kb, :ios)
    @tand = Bisu::Translator.new(kb, :android)
    @tror = Bisu::Translator.new(kb, :ror)
  end

  def test_simple_translate
    orig1 = "1: $specialKComment1$"
    orig2 = "2: $specialKComment2$"
    orig3 = "3: $specialKLanguage$"
    orig4 = "4: $specialKLocale$"
    orig5 = "5: $kRegularKey$"

    loc1 = "1: This file was automatically generated based on a translation template."
    loc2 = "2: Remember to CHANGE THE TEMPLATE and not this file!"
    loc3 = "3: #{@lang.upcase}"
    loc4 = "4: #{@locale}"
    loc5 = "5: Não sabes nada João das Neves"

    [@tios, @tand, @tror].each do |translator|
      assert_equal translator.send(:localize, orig1, @lang, @locale), loc1
      assert_equal translator.send(:localize, orig2, @lang, @locale), loc2
      assert_equal translator.send(:localize, orig3, @lang, @locale), loc3
      assert_equal translator.send(:localize, orig4, @lang, @locale), loc4
      assert_equal translator.send(:localize, orig5, @lang, @locale), loc5
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
