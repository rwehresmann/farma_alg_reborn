class AddCompoundIndexToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_index :answers, [:user_id, :team_id, :question_id], name: "correct_answer_index", where: "(correct is FALSE)"
  end
end
