require 'spec_helper'

describe "creating recipes" do
  context "on the new recipe page" do
    before do
      visit new_recipe_path
    end

    it "should have a form to create the recipes" do
      expect(page).to have_css("form#new_recipe")
    end

    it "should create a recipe when the form is submitted" do
      fill_in 'recipe_name', with: 'Candy Corn Dumplings'
      click_button('Create Recipe')

      Recipe.first.name.should == "Candy Corn Dumplings"
      expect(page).to have_content("Candy Corn Dumplings")
    end

    it "should create a recipe with one ingredient" do
      Ingredient.create(name: 'Spam')

      fill_in 'recipe_name', with: 'Spam Cakes'

      check('Spam Cakes')
      click_button('Create Recipe')

      Recipe.first.ingredients.where(name: 'Spam Cakes').count.should == 1
    end

    it "should create a recipe with many ingredients" do
      Ingredient.create(name: 'Paprika')
      Ingredient.create(name: 'Clove')
      Ingredient.create(name: 'Ginger')
      Ingredient.create(name: 'Cider')

      fill_in 'recipe_name', with: 'Holiday Spice Cider'

      check('Paprika')
      check('Clove')
      check('Ginger')
      check('Cider')

      click_button('Create Recipe')

      Recipe.first.ingredients.count.should == 4
    end

    it "should create a recipe with 0 ingredients" do
      fill_in 'recipe_name', with: 'Recipe in Progress'

      click_button('Create Recipe')

      Recipe.first.ingredients.count.should == 0
    end
  end
end
