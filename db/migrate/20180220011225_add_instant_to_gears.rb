class AddInstantToGears < ActiveRecord::Migration[5.0]
  def change
    add_column :gears, :instant, :integer, default: 1
  end
end
