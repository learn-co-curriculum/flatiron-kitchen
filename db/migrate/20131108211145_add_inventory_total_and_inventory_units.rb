class AddInventoryTotalAndInventoryUnits < ActiveRecord::Migration
  def change
    add_column :ingredients, :inventory_total, :float
    add_column :ingredients, :inventory_units, :string
  end
end
