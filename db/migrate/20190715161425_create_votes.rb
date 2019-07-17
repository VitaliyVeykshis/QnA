class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :vote_for, inclusion: [-1, 1], null: false
      t.references :votable, polymorphic: true, index: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
