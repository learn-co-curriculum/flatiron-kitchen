class CreateRecipeIngredients < ActiveRecord::Migration
  def change
    create_table :recipe_ingredients do |t|
      t.integer :recipe_id
      t.integer :ingredient_id

      t.timestamps null: false
    end
    add_index :recipe_ingredients, :recipe_id
    add_index :recipe_ingredients, :ingredient_id
  end
end
