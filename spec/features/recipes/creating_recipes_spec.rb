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
  end
end
