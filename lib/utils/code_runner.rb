require 'open3'

class CodeRunner
  PATH_TO_SAVE = "tmp/"
  COMPILER_OUTPUT_END_FILE_NAME = "_compiler_output"
  COMPILED_LANGUAGES = ["pas", "c"]

  attr_accessor :file_name, :extension, :source_code

  # @file_path = the source code file name (.ext) plus the path where should be saved.
  # @compiler_log_path = the same that @file_path, but instead the source code,
  #                      is the compiler log that is saved.
  def initialize(args = {})
    @file_name = args[:file_name]
    @extension = args[:extension]
    @file_path = "#{PATH_TO_SAVE}#{file_name}.#{extension}"
    @compiler_log_path = "#{PATH_TO_SAVE}#{file_name}#{COMPILER_OUTPUT_END_FILE_NAME}.txt"
    @source_code = args[:source_code]
  end

  # Main method to call.
  def run(options = {})
    if compiled_language?
      compile unless options[:not_compile]
      return compiler_output_content if has_compilation_error?
    end

    case extension
    when "pas", "c"
        command = "./#{PATH_TO_SAVE}#{@file_name}"
        execute_program(command, options[:inputs])
      else
        raise "CodeRunner doesn't support '.#{extension}' files."
    end
  end

  def compile
    save_source_code

    case @extension
      when "pas"
        `fpc #{@file_path} -Fe#{@compiler_log_path}`
      when "c"
        `gcc #{@file_path} -o #{PATH_TO_SAVE}#{@file_name} 2> #{@compiler_log_path}`
      else
        raise "CodeRunner doesn't support '.#{extension}' files."
    end
  end

    private

    # Join command to be executed with the informed params, if there are params.
    def execute_program(command, params)
      result = ""

      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        begin
          Timeout.timeout(10) do
            params.each { |param| stdin.puts(param) } if params
            output = stdout.read
            error = stderr.read

            stdin.close
            stdout.close
            stderr.close

            result = error == "" ? output : error
          end

          if result.strip.empty?
            return "[Seu código fonte não imprimiu nenhuma saída]" if @extension == "pas"
            "Seu código fonte não imprimiu nenhuma saída. Os principais motivos disso poder ser: (1) nenhuma saída foi especificada no código fonte (2) ou ele está gerando um erro de segmentação (Segmentation fault)" if @extension == "c"
          else
            result
          end
        rescue Timeout::Error
          # here you know that the process took longer than 10 seconds
          Process.kill("KILL", wait_thr.pid)
          "Erro de timeout. Possívelmente, seu código entrou num loop infinito."
        end
      end
    end

    # If file with the compiler log is created, that points that the source code
    # is already compiled.
    def compiled?
      File.file?(@compiler_log_path)
    end

    # If only check exitstatus, that can leave errors if the code runner
    # compile a sequence of source codes, like in a test suite, for example. So
    # we check first if the filed is compiled, and then the exitstatus which is
    # indeed the exitstatus from the compilation of this source code (because
    # is called right after the compile method, inside run method).
    def has_compilation_error?
      return $?.exitstatus != 0 if compiled?
      raise "You need compile your source code first."
    end

    def save_source_code
      File.open(@file_path, 'w') { |f| f.write(source_code) }
    end

    # Get the compiler log output as a string.
    def compiler_output_content
      File.open(@compiler_log_path).read
    end

    # Check if the extension represents an extension of a compiled language
    # that CodeRunner is prepared to support.
    def compiled_language?
      COMPILED_LANGUAGES.include?(@extension)
    end
end
