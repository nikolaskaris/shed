class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.text :comment
      t.integer :star
      t.references :gear, foreign_key: true
      t.references :reservation, foreign_key: true
      t.references :borrower, foreign_key: { to_table: :users }
      t.references :owner, foreign_key: { to_table: :users }
      t.string :type

      t.timestamps
    end
  end
end
