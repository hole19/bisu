describe Object do

  describe "#deep_symbolize" do
    subject { obj.deep_symbolize }

    context "when object is an Hash" do
      let(:obj) { { "key1" => "value1", key2: "value2" } }
      it { should eq({ key1: "value1", key2: "value2" }) }

      context "with inner Hashes" do
        before { obj["key2"] = { "key3" => { "key4" => "value4" } } }
        it { should eq({ key1: "value1", key2: { key3: { key4: "value4" } }}) }
      end
    end

    context "when object is an Array" do
      let(:obj) { ["value1"] }
      it { should eq obj }

      context "with inner Hashes" do
        let(:obj) { [{ "key1" => "value1" }, { "key2" => "value2" }] }
        it { should eq([{ key1: "value1" }, { key2: "value2" }]) }
      end
    end

    context "when object is something else" do
      let(:obj) { "value1" }
      it { should eq obj }
    end
  end

  describe "#validate_structure!" do
    subject { obj.validate_structure!(structure) }

    context "when object type differs of the structure type" do
      let(:obj) { "a string" }
      let(:structure) { { type: Integer } }
      it { expect { subject }.to raise_error /expected Integer, got String/i }
    end

    context "when object is a Nil" do
      let(:obj) { nil }
      let(:structure) { { type: Integer } }
      it { expect { subject }.to raise_error /expected Integer, got NilClass/i }

      context "but is also optional" do
        before { structure[:optional] = true }
        it { expect { subject }.not_to raise_error }
      end
    end

    context "when object is an Array" do
      let(:obj) { ["elem1", "elem2"] }
      let(:structure) { { type: Array } }
      it { expect { subject }.not_to raise_error }

      context "given an element structure" do
        before { structure[:elements] = { type: String } }
        it { expect { subject }.not_to raise_error }

        context "which is not respected" do
          before { structure[:elements] = { type: Integer } }
          it { expect { subject }.to raise_error /expected Integer, got String/i }
        end
      end
    end

    context "when object is an Hash" do
      let(:obj) { { key1: "value1", key2: "value2", key3: "value3" } }
      let(:structure) { { type: Hash } }
      it { expect { subject }.not_to raise_error }

      context "when given an element structure" do
        let(:structure) { { type: Hash, elements: { key1: { type: String }, key2: { type: String }, key3: { type: String } } } }
        it { expect { subject }.not_to raise_error }

        context "which is not respected" do
          before { obj[:key2] = {} }
          it { expect { subject }.to raise_error /expected String, got Hash/i }
        end

        context "when missing keys" do
          before do
            obj.delete(:key1)
            obj.delete(:key3)
          end
          it { expect { subject }.to raise_error /missing keys: key1, key3/i }

          context "which are optional" do
            before do
              structure[:elements][:key1][:optional] = true
              structure[:elements][:key3][:optional] = true
            end
            it { expect { subject }.not_to raise_error }
          end
        end
      end
    end
  end
end
