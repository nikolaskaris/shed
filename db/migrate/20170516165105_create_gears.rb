class CreateGears < ActiveRecord::Migration[5.0]
  def change
    create_table :gears do |t|
      t.string :activity
      t.string :gear_type
      t.string :size
      t.string :listing_name
      t.text :summary
      t.string :location
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
