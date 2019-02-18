describe Bisu::Source::GoogleSheet do
  subject(:to_i18) { Bisu::Source::GoogleSheet.new(sheet_id, key_column).to_i18 }

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

    it "returns an hash in i18 format" do
      expect(to_i18).to eq({
        "english"    => { "kConnectFacebook" => "Connect with Facebook",  "kConnectEmail" => "Connect with Email" },
        "german"     => { "kConnectFacebook" => "Mit Facebook verbinden", "kConnectEmail" => "Mit E-Mail verbinden" },
        "portuguese" => { "kConnectFacebook" => "Registar com Facebook",  "kConnectEmail" => "Registar com Email" },
        "spanish"    => { "kConnectFacebook" => "Conéctate con Facebook", "kConnectEmail" => "Conéctate con Email" },
        "french"     => { "kConnectFacebook" => "Connecter Facebook" },
        "dutch"      => { "kConnectFacebook" => "Facebook Verbinden",     "kConnectEmail" => "Email Verbinden" },
        "korean"     => { "kConnectFacebook" => "페이스북으로 접속",           "kConnectEmail" => "이메일로 접속" },
        "japanese"   => { "kConnectFacebook" => "フェイスブックへ接続",      "kConnectEmail" => "電子メールアカウントに接続" }
     })
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
