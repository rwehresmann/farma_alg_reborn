require 'rails_helper'

describe MossMatcher do
  describe '#call' do
    context "when none source code is provided" do
      subject { described_class.new(source_codes: []).call }
      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context "when source codes nothing similar are provided" do
      subject { described_class.new(source_codes: unrelated_source_codes).call }

      it { is_expected.to eq 0 }
    end

    context "when similar source codes are provided" do
      subject do
        result = described_class.new(source_codes: related_source_codes).call
        result.class
      end

      it { is_expected.to eq Fixnum }
    end
  end

  def unrelated_source_codes
    sc1 = IO.read("spec/support/files/hello_world.pas")
    sc2 = IO.read("spec/support/files/params.pas")

    [sc1, sc2]
  end

  def related_source_codes
    sc1 = IO.read("spec/support/files/hello_world.pas")
    sc2 = IO.read("spec/support/files/hello_world_2.pas")

    [sc1, sc2]
  end
end
