require 'rails_helper'
require 'utils/code_runner'

describe CodeRunner do
  describe '#run' do
    context "when try to run a pascal source code" do
      context "with input" do
        let(:file_name) { SecureRandom.hex }
        let(:source_code) { IO.read("spec/support/files/params.pas") }
        let(:code_runner) { CodeRunner.new(file_name: SecureRandom.hex,
                                           extension: "pas", source_code: source_code) }

        subject { code_runner.run(inputs: [4, 3]) }

        it { expect(subject).to match("7\n") }
      end

      context "when source code is right" do
        let(:file_name) { SecureRandom.hex }
        let(:source_code) { IO.read("spec/support/files/hello_world.pas") }
        let!(:code_runner) { CodeRunner.new(file_name: file_name, extension: "pas",
                                            source_code: source_code) }

        it "returns the source code output" do
          result = code_runner.run
          expect(result).to eq("Hello, world.\n")
        end
      end

      context "when not_compile: true" do
        let(:source_code) { IO.read("spec/support/files/hello_world.pas") }

        subject { code_runner.run(not_compile: true) }

        context "when already compiled" do
          let(:file_name) { SecureRandom.hex }
          let!(:code_runner) { CodeRunner.new(file_name: file_name, extension: "pas",
                                              source_code: source_code) }

          before do
            code_runner.send(:save_source_code)
            code_runner.send(:compile)
          end

          it { expect(subject).to eq("Hello, world.\n") }
        end

        context "when isn't already compiled" do
          let(:file_name) { SecureRandom.hex }
          let!(:code_runner) { CodeRunner.new(file_name: file_name, extension: "pas",
                                              source_code: source_code) }

          it { expect { subject }.to raise_error(RuntimeError) }
        end
      end

      context "when source code has compilation errors" do
        let(:file_name) { SecureRandom.hex }
        let(:source_code) { IO.read("spec/support/files/hello_world_compilation_error.pas") }
        let!(:code_runner) { CodeRunner.new(file_name: file_name, extension: "pas",
                                            source_code: source_code) }

        it "returns the compiler log" do
          result = code_runner.run
          expect(result.scan(/(?i)error/).empty?).to be_falsey
        end
      end
    end

    context "when try to run C file" do
      context "when source code is right" do
        it "returns the expected output" do
          source_code = IO.read("spec/support/files/sum_two_numbers.c")
          output = run_c_source_code(source_code)

          expect(output).to eq("3")
        end

        context "but causes segmentation fault" do
          it "returns the bash output" do
            source_code = IO.read("spec/support/files/sum_two_numbers_segmentation_fault.c")
            output = run_c_source_code(source_code)

            expect(output).to match(/Segmentation fault/)
          end
        end
      end

      context "when source code is wrong" do
        it "returns the compiler output" do
          source_code = IO.read("spec/support/files/c_compilation_error.c")
          output = run_c_source_code(source_code)

          expect(output).to match(/(?i)error/)
        end
      end
    end
  end
end

def run_c_source_code(source_code)
  described_class.new(
    file_name: SecureRandom.hex,
    extension: "c",
    source_code: source_code
  ).run(inputs: [1, 2])
end
