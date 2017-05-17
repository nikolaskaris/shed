class AddPriceToGear < ActiveRecord::Migration[5.0]
  def change
    add_column :gears, :price, :integer
  end
end
