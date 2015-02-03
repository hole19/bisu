require 'minitest/autorun'
require 'bisu/config'

class BisuConfigTest < Minitest::Test

  def test_parse
    config = Bisu::Config.parse("test/support/sample_translatable.yml")

    assert_equal config[:type], "iOS"
    assert_equal config[:sheet_id], "abc1234567890"
    assert_equal config[:keys_column], "key_name"
    
    assert_equal config[:in], [
      "folder/file_1.translatable",
      "folder/file_2.translatable"
    ]
    
    assert_equal config[:out], [
      { language: "english", folder: "hole19/en.lproj/" },
      { language: "portuguese", folder:   "hole19/pt.lproj/" }
    ]
  end
end
