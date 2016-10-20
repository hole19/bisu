describe Bisu::GoogleDriveKB do
  subject(:kb) { Bisu::GoogleDriveKB.new(sheet_id, key_column) }

  let(:sheet_id) { "abc1234567890" }
  let(:key_column) { "key_column" }

  let(:url_info)  { "https://spreadsheets.google.com/feeds/worksheets/#{sheet_id}/public/full" }
  let(:url_sheet) { "https://spreadsheets.google.com/feeds/list/#{sheet_id}/od6/public/full" }

  context "when given a valid sheet_id" do
    let(:file_info)  { File.read("spec/fixtures/sample_kb_public_info.html") }
    let(:file_sheet) { File.read("spec/fixtures/sample_kb_public_sheet.html") }

    before do
      stub_request(:get, url_info).to_return(:status => 200, :body => file_info, :headers => {})
      stub_request(:get, url_sheet).to_return(:status => 200, :body => file_sheet, :headers => {})
    end

    it do
      expect { kb }.not_to raise_error
    end
  end
end
