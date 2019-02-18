describe Bisu::Source::Url do
  subject(:to_i18) { Bisu::Source::Url.new(url).to_i18 }

  let(:url) { "https://in17n-08c12b370aeb6c66.herokuapp.com/documents/1/json?api_key=0320cd5d-1a51-4785-a832-a5bed8e62ed6" }
  let(:os_response) { File.read("spec/fixtures/sample_json_response.json") }

  def stub_url(status:, response:)
    stub_request(:get, url).
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
