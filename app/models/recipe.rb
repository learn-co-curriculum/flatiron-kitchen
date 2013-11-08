class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  def recipe_ingredient_attrs=(ri_attrs)
    ri_attrs.keep_if { |ria| ria[:ingredient_id].present? }

    ri_attrs.each do |attrs|
      self.recipe_ingredients.build(attrs)
    end

    ingredients = Ingredient.where("id in (?)", ingredient_ids)
    self.ingredients = ingredients
  end
end
