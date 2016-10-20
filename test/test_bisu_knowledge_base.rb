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
end
