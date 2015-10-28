## Flatiron Kitchen Tutorial

In this lab, we're practicing using Rails' form helpers to create our recipe saving site (your mom will love it). After running the spec, we get a general idea of the functionality that we want. For now, we have a pretty simple domain model - recipes can have many ingredients, and ingredients can have many associated recipes. Our Recipes and Ingredients will be simple for now and just include a `name`. Users will be able to create new ingredients and create new recipes using forms. 

### Setting Up The Schema

To begin, let's make a list of everything that we know we're going to need. Since we have two main models plus a many-to-many relationship, we know we'll need the following. 

+ For Ingredient:
  1. A migration to create the table
  2. A model
  3. A controller
  4. 7 RESTful routes
  5. Views to correspond to the routes
+ For Recipe: 
  1. A migration to create the table
  2. A model
  3. A controller
  4. RESTful rotues
  5. Views to correspond to the routes
+ For our join, RecpieIngredient, we'll need:
  1. A migration to create the table
  2. A corresponding model

We can get everything we need using the rails generators - this is faster and less error-prone than building everything out ourselves. We can get most of what we need for `Ingredient` and `Recipe` by generating a `resource`. Generating a `resource` gives us a migration, a model, controller, and corresponding routes. The views we'll build out ourselves. 

You may be asking, "Why not generate a scaffold? That will generate the views for us, too!" It's true, but at this point, I want more control over which view files will be generated and what they will contain. I'd rather build out my views from scratch rather than have to remove what I don't want. 

run `rails g resource ingredient name:string`, `rails g resource recipe name:string` to generate migrations, models, routes, and controllers for Ingredient and Recipe. 

Finally, we need a model and migration for our join table - for this we can run `rails g model recipe_ingredient ingredient:references recipe:references` to generate a model and migration. 

Rails should generate the following code for us - if not, don't worry, you can edit these files yourself. 

```ruby
# db/migrate/create_ingredients
class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
```

```ruby
# db/migrate/create_recipes
class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
```

```ruby
# db/migrate/create_recipe_ingredients
class CreateRecipeIngredients < ActiveRecord::Migration
  def change
    create_table :recipe_ingredients do |t|
      t.references :ingredient
      t.references :recipe

      t.timestamps null: false
    end
  end
end

```

Run these migrations using `rake db:migrate` and `rake db:migrate RAILS_ENV=test` - you should see the following in your schema file:

```ruby
ActiveRecord::Schema.define(version: 20151028140014) do

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.integer  "ingredient_id"
    t.integer  "recipe_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
```

Lastly, let's associate our models with each other so that an ingredient `has_many` recipes and a recipe `has_many` ingredients. We'll also make sure that our ingredients and recipes are invalid without a name.

```ruby
# app/models/ingredient.rb
class Ingredient < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true
end

```

```ruby
# app/models/recipe.rb
class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :ingridents, through: :recipe_ingredients

  validates :name, presence: true
end

```

```ruby
# app/models/recipe_ingredients.rb
class Ingredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :ngredients
end

```

### Setting Up Our Forms





