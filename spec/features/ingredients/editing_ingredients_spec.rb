require 'spec_helper'

describe "editing ingredients" do
  context "on the edit ingredient page" do
    before do
      @ingredient = Ingredient.create("Salmon Flanks")
      visit edit_ingredient_path(@ingredient)
    end

    it "should have a form to edit the ingredient" do
      expect(page).to have_css("form#edit_ingredient")
    end

    it "should updae an ingredient when the form is submitted" do
      fill_in 'ingredient_name', with: 'Rochester Pollywog Eggs'
      click_button('Update Ingredient')

      Ingredient.first.name.should == "Rochester Pollywog Eggs"
      expect(page).to have_content("Rochester Pollywog Eggs")
    end
  end
end
