module Compilers
  PATH_TO_SAVE = "tmp/"
  COMPILER_OUTPUT_END_FILE_NAME = "_compiler_output"

  # Compile the source code and run it, if compiled succesfully. Return the
  # compiler output if not compiled succesfully, else the result of the
  # source code exercution.
  def compile_and_run(file_name, file_ext, source_code, input)
    compiler_output = compile(file_name, file_ext, source_code)
    return compiler_output if has_error?
    run(file_name, file_ext, source_code, input)
  end

  # Run the compiled source code, or return the compiler log if you try to run
  # a source code who doesn't compiled succesfully.
  def run(file_name, file_ext, source_code, input)
    return "Not possible run because compilation error:\n\n#{compiler_output_content(file_name)}" if has_error?
    `./#{PATH_TO_SAVE}#{file_name} input`
  end

  # Compile the source code and return the compiler output.
  def compile(filename, file_ext, source_code)
    file = file_full_path(filename, file_ext)
    save_source_code(file, source_code)

    if file_ext == "pas"
      `fpc #{file} -Fe#{compiler_output_full_path(filename)}`
    else
      raise "The app doesn't support '.#{lang_ext}' files."
    end
    compiler_output_content(filename)
  end

  # Check if compilation presents errors. 'exitstatus' gets the shell last
  # command status, so be sure to, if you need to check it, don't call it
  # after execute other shell command. Also a error message is raised if you
  # call this method without compiled the source code first.
  def has_error?
    raise "Undefined 'exitstatus'. Have you compiled your source code first?" unless defined?($?.exitstatus)
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
