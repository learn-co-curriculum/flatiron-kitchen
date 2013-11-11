class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  def total_makeable
    self.recipe_ingredients.map do |recipe_ingredient|
      if recipe_ingredient.quantity && recipe_ingredient.quantity > 0
        recipe_ingredient.ingredient.inventory_total / recipe_ingredient.quantity
      else
        0
      end
    end.min
  end

  def recipe_ingredient_attrs=(ri_attrs)
    ri_attrs.keep_if { |ria| ria[:ingredient_id].present? }

    self.recipe_ingredients.destroy_all
    ri_attrs.each do |attrs|
      self.recipe_ingredients.build(attrs)
    end

    self.save
  end

  def quantity_for(ingredient)
    ri = self.recipe_ingredients.where(ingredient: ingredient).first
    ri.quantity if ri
  end
end
