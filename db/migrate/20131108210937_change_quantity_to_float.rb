class ChangeQuantityToFloat < ActiveRecord::Migration
  def change
    change_column :recipe_ingredients, :quantity, :float
  end
end
