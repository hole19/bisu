describe Bisu::GoogleSheet do
  subject(:to_i18) { Bisu::GoogleSheet.new(sheet_id, key_column).to_i18 }

  let(:sheet_id) { "abc1234567890" }
  let(:url_info)  { "https://spreadsheets.google.com/feeds/worksheets/#{sheet_id}/public/full" }
  let(:url_sheet) { "https://spreadsheets.google.com/feeds/list/#{sheet_id}/od6/public/full" }

  let(:key_column) { "key_column" }

  context "when given a valid sheet" do
    let(:file_info)  { File.read("spec/fixtures/sample_kb_public_info.html") }
    let(:file_sheet) { File.read("spec/fixtures/sample_kb_public_sheet.html") }

    before do
      stub_request(:get, url_info).to_return(:status => 200, :body => file_info, :headers => {})
      stub_request(:get, url_sheet).to_return(:status => 200, :body => file_sheet, :headers => {})
    end

    it do
      expect { to_i18 }.not_to raise_error
    end

    it "returns an hash" do
      expect(to_i18).to include("korean", "spanish")
      expect(to_i18["korean"]).to include("kConnectEmail", "kConnectFacebook")
      expect(to_i18["spanish"]).to include("kConnectEmail" => "Conéctate con Email")
    end

    context "but the key column is not present in the first sheet" do
      let(:key_column) { "expecting_another_key_column" }

      it do
        expect { to_i18 }.to raise_error /Cannot find key column/
      end
    end
  end

  context "when given an inexistent sheet" do
    before { stub_request(:get, url_info).to_return(:status => 400, :body => "Not Found", :headers => {}) }

    it do
      expect { to_i18 }.to raise_error /Cannot access sheet/
    end
  end

  context "when given a private sheet" do
    before { stub_request(:get, url_info).to_return(:status => 302, :body => "<HTML></HTML>", :headers => {}) }

    it do
      expect { to_i18 }.to raise_error /Cannot access sheet/
    end
  end

  context "when url content is not XML" do
    before { stub_request(:get, url_info).to_return(:status => 200, :body => "This is not XML; { this: \"is json\" }", :headers => {}) }

    it do
      expect { to_i18 }.to raise_error /Cannot parse. Expected XML/
    end
  end
end
