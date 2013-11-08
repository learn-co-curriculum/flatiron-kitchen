class RecipeIngredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :ingredient

  validates_uniqueness_of :recipe_id, :scope => :ingredient_id
end
