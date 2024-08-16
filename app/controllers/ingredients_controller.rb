class IngredientsController < ActionController::Base
  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    if @ingredient.save
      redirect_to ingredient_path(@ingredient)
    else
      # If save fails, render the 'new' template again with errors
      render :new
    end
  end

  def show
    @ingredient = Ingredient.find(params[:id])
  end

  def edit
    @ingredient = Ingredient.find(params[:id])
  end

  def update
    ingredient = Ingredient.find(params[:id])
    ingredient.update(ingredient_params)
    redirect_to ingredient_path(ingredient)
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:name)
  end
end
