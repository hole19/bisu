require 'minitest/autorun'
require 'bisu/knowledge_base'

class BisuKnowledgeBaseTest < Minitest::Test

  def test_parsing
    stub_request(:get, "https://spreadsheets.google.com/feeds/worksheets/abc1234567890/public/full").to_return(
      status: 200, body: File.read("test/support/sample_kb_public_info.html"), headers: {})

    stub_request(:get, "https://spreadsheets.google.com/feeds/list/abc1234567890/od6/public/full").to_return(
      status: 200, body: File.read("test/support/sample_kb_public_sheet.html"), headers: {})

    Bisu::Logger.silent_mode = true

    Bisu::GoogleDriveKB.new("abc1234567890", "key_column")

    Bisu::Logger.silent_mode = false
  end

  def test_has_language?
    kb = Bisu::KnowledgeBase.new({
      languages: ["portuguese"],
      keys: {}
    })
    
    assert_equal kb.has_language?("kriolo"),     false
    assert_equal kb.has_language?("portuguese"), true
  end

  def test_localize
    key      = "kYouKnowNothingJohnSnow"
    pt_trans = "Não sabes nada João das Neves"

    kb = Bisu::KnowledgeBase.new({
      languages: ["portuguese"],
      keys: { key => { "portuguese" => pt_trans } }
    })

    assert_equal kb.localize(key, "kriolo"),     nil
    assert_equal kb.localize(key, "portuguese"), pt_trans
  end
end
