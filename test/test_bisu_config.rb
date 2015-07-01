require 'minitest/autorun'
require 'bisu/config'

class BisuConfigTest < Minitest::Test

  def test_parse
    config = Bisu::Config.parse("test/support/sample_translatable.yml")

    assert_equal config[:type], "BisuOS"
    assert_equal config[:sheet_id], "abc1234567890"
    assert_equal config[:keys_column], "key_name"
    
    assert_equal config[:in], [
      "path/to/file/to/1.ext.translatable",
      "path/to/file/to/2.ext.translatable"
    ]
    
    assert_equal config[:out_path], "path/to/final-%{locale}/%{out_name}"

    assert_equal config[:out], [
      { locale: "en",    kb_language: "english", path: "path/to/default/%{out_name}" },
      { locale: "pt",    kb_language: "portuguese" },
      { locale: "pt-PT", kb_language: "portuguese" }
    ]
  end
end
