describe Bisu::Source::GoogleSheet do
  subject(:to_i18) { Bisu::Source::GoogleSheet.new(url).to_i18 }

  let(:url) { "https://docs.google.com/spreadsheets/d/e/2PACX-1vTm6yu_zfbxKizC-PvUE1HVFCsplmiyz0s0qLSIGeokA7KtS3BgtqaA79CsfYfPsXH6xzUaP8HDTcj8/pub?gid=0&single=true&output=csv" }
  let(:response) { File.read("spec/fixtures/sample_google_response.csv") }

  def stub_url(status:, response:)
    stub_request(:get, url).
      to_return(:status => status, :body => response, :headers => {})
  end

  before { stub_url(status: 200, response: response) }

  it do
    expect { to_i18 }.not_to raise_error
  end

  it "returns an hash in i18 format" do
    expect(to_i18).to eq({
      "en" => { "kConnectFacebook" => "Connect with Facebook", "kNoNoNoMr" => "No, no, no. Mr %{name} not here" },
      "ja" => { "kConnectFacebook" => "フェイスブックへ接続" },
      "fr" => { "kConnectFacebook" => "Connexion par Facebook" },
      "de" => { "kConnectFacebook" => "Mit Facebook verbinden" },
      "ko" => { "kConnectFacebook" => "페이스북으로 접속", "kTwitterServer" => "트위터 서버연결 실패. \\n잠시 후 재시도." }
   })
  end

  context "when given an inexistent sheet" do
    before { stub_url(status: 400, response: "Not Found") }

    it do
      expect { to_i18 }.to raise_error /Http Error/
    end
  end

  context "when url content is not CSV" do
    before { stub_url(status: 200, response: "{\"asdsa\": \"This is a json\"}") }

    it do
      expect { to_i18 }.to raise_error /Cannot parse. Expected CSV/
    end
  end
end
