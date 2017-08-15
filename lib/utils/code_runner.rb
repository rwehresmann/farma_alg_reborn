require 'open3'

class CodeRunner
  COMPILER_OUTPUT_END_FILE_NAME = "_compiler_output"
  COMPILED_LANGUAGES = ["pas", "java"]

  attr_accessor :file_name, :extension, :source_code

  # @file_path = the source code file name (.ext) plus the path where should be saved.
  # @compiler_log_path = the same that @file_path, but instead the source code,
  #                      is the compiler log that is saved.
  def initialize(args = {})
    @path_to_save = "tmp/#{SecureRandom.hex}/"
    @file_name = args[:file_name]
    @extension = args[:extension]
    @file_path = "#{@path_to_save}#{file_name}.#{extension}"
    @compiler_log_path = "#{@path_to_save}#{file_name}#{COMPILER_OUTPUT_END_FILE_NAME}.txt"
    @source_code = args[:source_code]
  end

  # Main method to call.
  def run(options = {})
    if compiled_language?
      compile unless options[:not_compile]
      return compiler_output_content if has_compilation_error?
    end

    case extension
      when "pas"
        command = "./#{@path_to_save}#{file_name}"
        to_exec(command, options[:inputs])
      when "java"
        command = "cd #{@path_to_save} && java #{file_name}"
        to_exec(command, options[:inputs])
      else
        raise "CodeRunner doesn't support '.#{extension}' files."
    end
  end

  def compile
    save_source_code

    case @extension
    when "pas"
      `fpc #{@file_path} -Fe#{@compiler_log_path}`
    when "java"
      `javac #{@file_path} 2> #{@compiler_log_path}`
    else
      raise "CodeRunner doesn't support '.#{extension}' files."
    end
  end

    private

    # Join command to be executed with the informed params, if there are params.
    def to_exec(command, params)
      Open3.popen3(command) do |stdin, stdout, stderr, w|
        begin
          Timeout.timeout(10) do
            params.each { |param| stdin.puts(param) } if params
            output = stdout.read
            error = stderr.read
            stdin.close
            stdout.close
            stderr.close

            error == "" ? output : error
          end
        rescue Timeout::Error
          # here you know that the process took longer than 10 seconds
          Process.kill("KILL", w.pid)
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
      Dir.mkdir("#{@path_to_save}")
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
