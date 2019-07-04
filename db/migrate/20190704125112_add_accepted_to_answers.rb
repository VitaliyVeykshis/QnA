class AddAcceptedToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :accepted, :boolean, default: false, null: false
  end
end
