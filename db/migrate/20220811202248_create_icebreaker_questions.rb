class CreateIcebreakerQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :icebreaker_questions do |t|
      t.string :text

      t.timestamps
    end
  end
end
