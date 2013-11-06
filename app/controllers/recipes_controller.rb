class RecipesController < ApplicationController
  def index
  end

  def new
    @recipe = Recipe.new
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    recipe = Recipe.find(params[:id])
    recipe.update(recipe_params)
  end

  def recipe_params
    params.require(:recipe).permit(:name)
  end
end
