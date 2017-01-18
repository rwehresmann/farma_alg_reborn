class AddCompilationErrorAndCompilerOutputToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :compilation_error, :boolean, default: false
    add_column :answers, :compiler_output, :string
  end
end
