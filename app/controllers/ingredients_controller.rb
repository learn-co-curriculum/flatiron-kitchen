class IngredientsController < ApplicationController
  def index
    @ingredients = Ingredient.all
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    Ingredient.create(ingredient_params)

    redirect_to ingredients_path
  end

  private 

  def ingredient_params
    params.require(:ingredient).permit(:name)
  end
end
