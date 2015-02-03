require 'minitest/autorun'
require 'bisu/translator'

class BisuTranslatorTest < Minitest::Test

  def setup
    kb = Bisu::KnowledgeBase.new({
      languages: ["PT"],
      keys: {
        "kRegularKey"  => { "PT" => "Não sabes nada João das Neves" },
        "kIOSKey"      => { "PT" => "Não sabes nada \"João das Neves\"" },
        "kAndroidKey1" => { "PT" => "Não sabes nada 'João das Neves'" },
        "kAndroidKey2" => { "PT" => "Não sabes nada João das Neves..." },
        "kAndroidKey3" => { "PT" => "Não sabes nada João das Neves & Pícaros" },
      }
    })

    @tios = Bisu::Translator.new(kb, :ios)
    @tand = Bisu::Translator.new(kb, :android)
  end

  def test_simple_translate
    orig1 = "1: $specialKComment1$"
    orig2 = "2: $specialKComment2$"
    orig3 = "3: $specialKLanguage$"
    orig4 = "4: $kRegularKey$"

    loc1 = "1: This file was automatically generated based on a translation template."
    loc2 = "2: Remember to CHANGE THE TEMPLATE and not this file!"
    loc3 = "3: PT"
    loc4 = "4: Não sabes nada João das Neves"

    assert_equal @tios.send(:localize, orig1, "PT"), loc1
    assert_equal @tios.send(:localize, orig2, "PT"), loc2
    assert_equal @tios.send(:localize, orig3, "PT"), loc3
    assert_equal @tios.send(:localize, orig4, "PT"), loc4

    assert_equal @tand.send(:localize, orig1, "PT"), loc1
    assert_equal @tand.send(:localize, orig2, "PT"), loc2
    assert_equal @tand.send(:localize, orig3, "PT"), loc3
    assert_equal @tand.send(:localize, orig4, "PT"), loc4
  end

  def test_ios_translate
    assert_equal @tios.send(:localize, "1: $kIOSKey$", "PT"), "1: Não sabes nada \\\"João das Neves\\\""
  end

  def test_android_translate
    assert_equal @tand.send(:localize, "1: $kAndroidKey1$", "PT"), "1: Não sabes nada \\'João das Neves\\'"
    assert_equal @tand.send(:localize, "2: $kAndroidKey2$", "PT"), "2: Não sabes nada João das Neves…"
    assert_equal @tand.send(:localize, "3: $kAndroidKey3$", "PT"), "3: Não sabes nada João das Neves &amp; Pícaros"
  end
end
