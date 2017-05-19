class AddFieldsToGear < ActiveRecord::Migration[5.0]
  def change
    add_column :gears, :latitude, :float
    add_column :gears, :longitude, :float
  end
end
