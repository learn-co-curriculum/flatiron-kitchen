require 'spec_helper'

describe "editing recipes" do
  context "on the edit recipe page" do
    before do
      @recipe = Recipe.create(name: "Rice Pudding")
      visit edit_recipe_path(@recipe)
    end

    it "should have a form to edit the recipe" do
      expect(page).to have_css("form#edit_recipe_#{@recipe.id}")
    end

    it "should update an recipe when the form is submitted" do
      fill_in 'recipe_name', with: "Rice Pudding with Farmer Darryl's Frog Sauce"
      click_button('Update Recipe')

      Recipe.first.name.should == "Rice Pudding with Farmer Darryl's Frog Sauce"
      expect(page).to have_content("Rice Pudding with Farmer Darryl's Frog Sauce")
    end

    it "should be able to add ingredients" do
      Ingredient.create(name: 'Paprika')
      Ingredient.create(name: 'Clove')
      Ingredient.create(name: 'Ginger')
      Ingredient.create(name: 'Cider')

      visit edit_recipe_path

      check('Paprika')
      check('Clove')
      check('Ginger')
      check('Cider')

      click_button('Update Recipe')

      @recipe.ingredients.count.should == 4
    end

    it "should be able to remove ingredients" do
      @recipe.ingredients.create(name: 'Paprika')
      @recipe.ingredients.create(name: 'Clove')
      @recipe.ingredients.create(name: 'Ginger')
      @recipe.ingredients.create(name: 'Cider')

      @recipe.ingredients.count.should == 4

      visit edit_recipe_path

      uncheck('Paprika')
      uncheck('Clove')
      uncheck('Ginger')
      uncheck('Cider')

      click_button('Update Recipe')

      @recipe.ingredients.count.should == 0
    end
  end
end
