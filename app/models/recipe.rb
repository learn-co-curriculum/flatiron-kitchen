class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true

  def recipe_ingredients_attributes=(ri_attrs)
    ri_attrs.keep_if { |i, ria| ria[:ingredient_id].to_i > 0 }

    RecipeIngredient.transaction do
      self.recipe_ingredients.destroy_all
      ri_attrs.each do |i, attrs|
        self.recipe_ingredients.build(attrs)
      end

      self.save
    end
  end

  def quantity_for(ingredient)
    ri = self.recipe_ingredients.where(ingredient: ingredient).first
    ri.quantity if ri
  end

  def new_or_existing_recipe_ingredient(ingredient)
    self.recipe_ingredients.where(ingredient: ingredient).first_or_initialize
  end

  def has_ingredient?(ingredient)
    self.ingredient_ids.include?(ingredient.id)
  end
end
