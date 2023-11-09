describe Bisu::Source::Tolgee do
  subject(:to_i18) { Bisu::Source::Tolgee.new(api_key).to_i18 }

  let(:api_key)    { "a123" }
  let(:os_response) { File.read("spec/fixtures/sample_tolgee_response.zip") }

  def stub_url(status:, response:)
    stub_request(:get, "https://app.tolgee.io/v2/projects/export?format=JSON&structureDelimiter=").
      to_return(:status => status, :body => response, :headers => {})
  end

  before { stub_url(status: 200, response: os_response) }

  it { expect { to_i18 }.not_to raise_error }

  it "returns an hash in i18 format" do
    expect(to_i18).to eq({
      "en" => { "kConnectFacebook" => "Connect with Facebook", "kNoNoNoMr" => "No, no, no. Mr %{name} not here" },
      "ja" => { "kConnectFacebook" => "フェイスブックへ接続" },
      "fr" => { "kConnectFacebook" => "Connexion par Facebook" },
      "de" => { "kConnectFacebook" => "Mit Facebook verbinden" },
      "ko" => { "kConnectFacebook" => "페이스북으로 접속", "kTwitterServer" => "트위터 서버연결 실패. \\n잠시 후 재시도." }
    })
  end

  context "when get request to that URL raises an error" do
    before { stub_url(status: 400, response: { error: "ups... not allowed!" }.to_json) }

    it "raises that same error" do
      expect { to_i18 }.to raise_error /not allowed/
    end
  end
end
