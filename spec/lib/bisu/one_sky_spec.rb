describe Bisu::OneSky do
  subject(:to_i18) { Bisu::OneSky.new(api_key, api_secret, project_id, file_name).to_i18 }

  let(:api_key)    { "a123" }
  let(:api_secret) { "b123" }
  let(:project_id) { 98765 }
  let(:file_name)  { "file456.json" }

  let(:os_response) { File.read("spec/fixtures/sample_one_sky_response.txt") }

  before do
    project = double("OSProject")
    allow_any_instance_of(Onesky::Client).to receive(:project).with(project_id).and_return(project)
    allow(project).to receive(:export_multilingual).with(source_file_name: file_name, file_format: "I18NEXT_MULTILINGUAL_JSON").and_return(os_response)
  end

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

  context "when OneSky raises an error" do
    before { allow_any_instance_of(Onesky::Client).to receive(:project).and_raise("ups... not allowed!") }

    it "raises that same error" do
      expect { to_i18 }.to raise_error /not allowed/
    end
  end

  context "when OneSky returns the newline bug" do
    let(:os_response) { File.read("spec/fixtures/sample_one_sky_response_with_bug.txt") }

    it { expect { to_i18 }.not_to raise_error }

    it "returns an hash in i18 format with the newline bug fixed" do
      expect(to_i18).to eq({
        "en" => {
          "kRegularNewLine" => "This is the first line\\nthis is the second line",
          "kErrorNewLine" => "This is the first line\\nthis is the second line"
        }
      })
    end
  end
end
