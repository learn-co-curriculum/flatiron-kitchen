class IngredientsController < ApplicationController

  def show
    @ingredient = Ingredient.find(params[:id])
  end

  def edit
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    ingredient = Ingredient.new(ingredient_params)
    if ingredient.save
      redirect_to ingredient
    else
      render :new
    end
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:name)
  end
end
