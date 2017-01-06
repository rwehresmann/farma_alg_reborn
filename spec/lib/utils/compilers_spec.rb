require 'rails_helper'
require 'utils/compilers'

include Compilers

describe Compilers do
  describe '#run' do
    context "when source code is right" do
      let(:source_code) { File.open("spec/support/files/hello_world.pas").read }
      before { @result = run("test", "pas", source_code, "") }

      it "doesn't return error" do
        expect(has_error?).to be_falsey
      end

      it "returns the desired output" do
        expect(@result).to eq("Hello, world.\n")
      end
    end

    context "when source code is wrong" do
      let(:source_code) { "" }
      before { @result = run("test", "pas", source_code, "") }

      it "returns error" do
        expect(has_error?).to be_truthy
      end

      it "returns the error as output" do
        expect(@result.scan(/(?i)error/).empty?).to be_falsey
      end
    end
  end
end
