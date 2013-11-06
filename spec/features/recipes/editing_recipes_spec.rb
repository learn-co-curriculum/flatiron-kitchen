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
  end
end
