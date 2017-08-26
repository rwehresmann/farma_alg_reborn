class AddLangExtensionToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :lang_extension, :string, default: "pas", null: false
  end
end
