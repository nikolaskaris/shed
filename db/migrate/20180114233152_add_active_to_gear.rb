class AddActiveToGear < ActiveRecord::Migration[5.0]
  def change
    add_column :gears, :active, :boolean
  end
end
