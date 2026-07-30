describe Bisu::Source::Bisu do
  subject(:to_i18) { Bisu::Source::Bisu.new(api_key, host).to_i18 }

  let(:api_key)     { "bsu_a123" }
  let(:host)        { "translations.example.com" }
  let(:os_response) { File.read("spec/fixtures/sample_bisu_response.json", encoding: "UTF-8") }

  def stub_url(status:, response:, host: "translations.example.com")
    stub_request(:get, "https://#{host}/api/v1/export?languages=all&mode=flat").
      to_return(:status => status, :body => response, :headers => {})
  end

  before { stub_url(status: 200, response: os_response) }

  it { expect { to_i18 }.not_to raise_error }

  it "returns an hash in i18 format keyed by language code" do
    expect(to_i18).to eq({
      "en" => { "kConnectFacebook" => "Connect with Facebook", "kNoNoNoMr" => "No, no, no. Mr %{name} not here" },
      "ja" => { "kConnectFacebook" => "フェイスブックへ接続" },
      "pt-BR" => { "kConnectFacebook" => "Conectar com o Facebook" },
      "ko" => { "kConnectFacebook" => "페이스북으로 접속", "kTwitterServer" => "트위터 서버연결 실패. \\n잠시 후 재시도." }
    })
  end

  it "authenticates with a bearer token" do
    to_i18
    expect(WebMock).to have_requested(:get, "https://#{host}/api/v1/export?languages=all&mode=flat").
      with(headers: { "Authorization" => "Bearer #{api_key}" })
  end

  context "when get request to that URL raises an error" do
    before { stub_url(status: 400, response: { error: "ups... not allowed!" }.to_json) }

    it "raises that same error" do
      expect { to_i18 }.to raise_error /not allowed/
    end
  end
end
