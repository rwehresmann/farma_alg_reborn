require 'rails_helper'
require 'utils/compilers'

include Compilers
include ApplicationHelper

describe Compilers do
  describe '#run' do
    context "when source code is compiled -->" do
      let!(:file_name) { plain_current_datetime }
      before { compile(file_name, "pas", source_code) }

      context "when source code is right" do
        let(:source_code) { File.open("spec/support/files/hello_world.pas").read }
        let!(:result) { run(file_name, "pas", source_code, "") }

        it "doesn't return error" do
          expect(has_error?).to be_falsey
        end

        it "returns the desired output" do
          expect(result).to eq("Hello, world.\n")
        end
      end

      context "when source code is wrong -->" do
        let!(:file_name) { plain_current_datetime }
        let(:source_code) { "That doesn't compile" }
        let!(:result) { run(file_name, "pas", source_code, "") }

        it "returns error" do
          expect(has_error?).to be_truthy
        end

        it "returns the error as output" do
          expect(result.scan(/(?i)error/).empty?).to be_falsey
        end
      end
    end

    # TODO: Need to find a way to realod the Compilers module, because
    # '$?.exitstatus' from 'has_error?' is defined in the tests above, and
    # here should be not defined to this test pass.
    #
    # context "when source code isn't compiled" do
    #   subject {  run(plain_current_datetime, "pas", "some code", "") }

    #   it "raises an error" do
    #     expect { subject }.to raise_error(RuntimeError)
    #   end
    # end
  end

  describe '#compile_and_run' do
    context "when source code is right" do
      let(:source_code) { File.open("spec/support/files/hello_world.pas").read }
      let!(:result) { compile_and_run(plain_current_datetime, "pas", source_code, "") }

      it "doesn't return error" do
        expect(has_error?).to be_falsey
      end

      it "returns the desired output" do
        expect(result).to eq("Hello, world.\n")
      end
    end

    context "when source code is wrong" do
      let(:source_code) { "That doesn't compile" }
      let!(:result) { compile_and_run(plain_current_datetime, "pas", source_code, "") }

      it "returns error" do
        expect(has_error?).to be_truthy
      end

      it "returns the error as output" do
        expect(result.scan(/(?i)error/).empty?).to be_falsey
      end
    end
  end

  describe '#compile' do
    context "when source_code is wrong" do
      let(:source_code) { "That doesn't compile" }
      let!(:result) { compile(plain_current_datetime, "pas", source_code) }

      it "returns error" do
        expect(has_error?).to be_truthy
        expect(result).to_not be_nil
      end
    end

    context "when source code is right" do
      let(:source_code) { File.open("spec/support/files/hello_world.pas").read }
      let!(:result) { compile(plain_current_datetime, "pas", source_code) }

      it "doesn't return error" do
        expect(has_error?).to be_falsey
        expect(result).to_not be_nil
      end
    end
  end
end
