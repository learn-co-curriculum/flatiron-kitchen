describe "creating ingredients" do
  context "on the new ingredient page" do
    before do
      visit new_ingredients_path
    end

    it "should have a form to create the ingredients" do
      expect(page).to have_css("form#new_ingredient")
    end

    it "should create an ingredient when the form is submitted" do
      fill_in 'ingredient_name', with: 'Parsley'
      click('Create Ingredient')

      Ingredient.first.name.should == "Parsley"
      expect(page).to have_content("Parsley")
    end
  end
end
