class AddAnswerLanguageAllowedToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :answer_language_allowed, :string, default: "pascal", null: false
  end
end
