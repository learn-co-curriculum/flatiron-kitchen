class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def new
    @recipe = Recipe.new
    @ingredients = Ingredient.all
  end

  def edit
    @recipe = Recipe.find(params[:id])

    @all_ingredients = Ingredient.all
    @recipe_ingredients = @recipe.ingredients
  end

  def create
    recipe = Recipe.create(recipe_params)

    recipe.update_ingredients_by_id(params[:recipe][:ingredient_ids])

    redirect_to recipes_path
  end

  def update
    recipe = Recipe.find(params[:id])
    recipe.update(recipe_params)

    recipe.update_ingredients_by_id(params[:recipe][:ingredient_ids])

    redirect_to recipes_path
  end

  def recipe_params
    params.require(:recipe).permit(:name)
  end
end
