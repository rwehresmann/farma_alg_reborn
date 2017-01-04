module Compilers
  PATH_TO_SAVE = "tmp/"
  COMPILER_OUTPUT_END_FILE_NAME = "_compiler_output"

  # Main method to run a file. If compilations presents errors, show the
  # compiler log; else run the file and returns its output.
  def run(file_name, file_ext, source_code, input)
    compile(file_name, file_ext, source_code)

    if has_error?
      compiler_output_content(file_name)
    else
      `./#{PATH_TO_SAVE}#{file_name} input`
    end
  end

  # Method to treat all the compilations processes.
  def compile(file_name, file_ext, source_code)
    file = file_full_path(file_name, file_ext)
    save_source_code(file, source_code)

    # '-Fe' parameter says where save the compiler log.
    if file_ext == "pas"
      `fpc #{file} -Fe#{compiler_output_full_path(file_name)}`
    else
      raise "The app doesn't support '.#{lang_ext}' files."
    end
  end

  # Check if compilation presents errors. 'exitstatus' gets the shell last
  # command status, so be sure to, if you need to check it, don't call it
  # after execute other shell command.
  def has_error?
    $?.exitstatus != 0
  end

  # Get the compiler log output as a string.
  def compiler_output_content(file_name)
    File.open("#{compiler_output_full_path(file_name)}").read
  end

  # Get the compiler output file whit its full path.
  def compiler_output_full_path(file_name)
    "#{PATH_TO_SAVE}#{file_name}#{COMPILER_OUTPUT_END_FILE_NAME}.txt"
  end

  # Get file (source code) whit its full path.
  def file_full_path(file_name, lang_ext)
    "#{PATH_TO_SAVE}#{file_name}.#{lang_ext}"
  end

  # Save source code (file is compund from the file (name + extension)
  # and its path).
  def save_source_code(file, source_code)
    File.open(file, 'w') { |f| f.write(source_code) }
  end
end
