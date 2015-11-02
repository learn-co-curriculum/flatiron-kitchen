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
  belongs_to :ingredients
end

```

### Ingredient Forms

Next, we need to build out the ability for our users to create new Ingredients. How will we do that? Yep, with a form!

Because we generated a resource for ingredients, our seven RESTful routes are already created for us. Going to the route `ingredients/new` will route us to the new action in our Ingredients controller. By default, this will render a template called `new.html.erb` inside of `views/ingredients`. Let's create that new file now. This file should render a form to create a new ingredient.

We could, if we wanted to, write a plain old HTML form here. However, it will be much easier to maintain if we use Rails form helper methods. In this case, we can use `form_for`. `form_for` takes an object to update as an argument and yields you a "form builder object" that you can use to create labels and inputs. In this case, we'll pass in a newly created ingredient. 

```ruby
# views/ingredients/new.html.erb

<%= form_for Ingredient.new do |f| %>
  <%= f.text_field :name %>
  <%= f.submit %>
<% end %>
```

Because we want to keep as little Ruby code in our views as possible, let's create the new ingredient for our form in our Ingredients Controller instead and pass it into the form as an instance variable.


```ruby
# views/ingredients/new.html.erb

class IngredientsController < ApplicationController

  def new
    @ingredient = Ingredient.new
  end
```

```ruby
# controllers/ingredients_controller.rb

<%= form_for @ingredient do |f| %>
  <%= f.text_field :name %>
  <%= f.submit %>
<% end %>
```

The `form_for` will automatically define the method and action based on the object passed as an argument. In this case,  since the ingredient hasn't been persisted to the database, it will send a POST request to '/ingredients', which will route us to the `create` action in the ingredients controller. This is where we'll actually create the new ingredient.

```ruby
# views/ingredients/new.html.erb

class IngredientsController < ApplicationController

  def new
    @ingredient = Ingredient.new
  end
  
  def create
  	#we'll create the new ingredient here!
  end
```

In order to use mass assignment, Rails requires us to specify which parameters we'll accept as a part of our hash. We do this using a private method - in this case we'll call it `ingredient_params`. 

```ruby
# views/ingredients/new.html.erb

class IngredientsController < ApplicationController

  def new
    @ingredient = Ingredient.new
  end
  
  def create
  	Ingredient.create(ingredient_params)
  end
  
  private 

  def ingredient_params
    params.require(:ingredient).permit(:name)
  end
```

After our new ingredient is created, we need to redirect our user to a page to see their newly created information. Let's create an index page that lists out all of our ingredients. This page will be rendered at the '/ingredients' route, which corresponds to the `index` action in the ingredients controller. 

```ruby
# views/ingredients/new.html.erb

class IngredientsController < ApplicationController

  def index
  
  end
  def new
    @ingredient = Ingredient.new
  end
  
  def create
  	Ingredient.create(ingredient_params)
  end
  
  private 

  def ingredient_params
    params.require(:ingredient).permit(:name)
  end
```

We can now create new ingredients. Let's add the ability to edit them. Whenever we add a new feature to our application, we need to ask two things. First, does  our schema need to change? Secondly, what URL will the user use to access the feature? In this case, we already have our path defined as well - the `edit_ingredient_path` will be a get request to `/ingredients/:id/edit` that should render our edit form, and submitting that form will be a patch request to `ingredients/:id`. 

Let's create an `edit` action in our Ingredients controller. First, we'll load the the ingredient based on what is in params, then render a file called `edit.html.erb` in the `ingredients` directory. 

```ruby
class IngredientsController < ApplicationController
  ...

  def edit
    @ingredient = Ingredient.find(params[:id])
  end

```

We can use `form_for` to create our edit form as well. 

```erb
<%= form_for @ingredient do |f| %>
  <%= f.text_field :name %>
  <%= f.submit %>
<% end %>
```

Notice how this is identical to our `new` form? We can move this into a partial so we don't have to repeat this code. Create a file called `_form.html.erb` and move the code from our `edit` form inside. Our `new` and `edit` templates can now simply user the `render` method to display the `form` partial. 

```erb
# _form.html.erb
<%= form_for @ingredient do |f| %>
  <%= f.text_field :name %>
  <%= f.submit %>
<% end %>
```

```erb
# new.html.erb
<%= render "form" %>
```

```erb
# edit.html.erb
<%= render "form" %>
```

### Recipe Forms

Now, our ingredients can be created and edited. Awesome! Let's add the same functionality for recipes. 




