require './lib/pantry'
require './lib/recipe'
require 'minitest/autorun'
require 'minitest/pride'

class PantryTest < Minitest::Test
  def setup
    @pantry = Pantry.new
    @r1 = Recipe.new("Cheese Pizza")
    @r1.add_ingredient("Cheese", 20)
    @r1.add_ingredient("Flour", 20)

    @r2 = Recipe.new("Pickles")
    @r2.add_ingredient("Brine", 10)
    @r2.add_ingredient("Cucumbers", 30)

    @r3 = Recipe.new("Peanuts")
    @r3.add_ingredient("Raw nuts", 10)
    @r3.add_ingredient("Salt", 10)
  end

  def test_it_exists
    assert_instance_of Pantry, @pantry
  end

  def test_pantry_creates_an_empty_hash
    assert_equal ({}), @pantry.stock
  end

  def test_it_returns_number_of_items_for_item_checked
    assert_equal 0, @pantry.stock_check("Cheese")
  end

  def test_it_can_restock_items
    assert_equal 0, @pantry.stock_check("Cheese")
    @pantry.restock("Cheese", 10)
    assert_equal 10, @pantry.stock_check("Cheese")
    @pantry.restock("Cheese", 20)
    assert_equal 30, @pantry.stock_check("Cheese")
  end

  def test_it_can_add_recipe_to_shopping_list
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 20)
    @pantry.add_to_shopping_list(r)

    expected = {"Cheese" => 20, "Flour" => 20}
    actual = @pantry.shopping_list

    assert_equal expected, actual

    r = Recipe.new("Spaghetti")
    r.add_ingredient("Spaghetti Noodles", 10)
    r.add_ingredient("Marinara Sauce", 10)
    r.add_ingredient("Cheese", 5)
    @pantry.add_to_shopping_list(r)

    expected_2 = {"Cheese" => 25, "Flour" => 20, "Spaghetti Noodles" => 10, "Marinara Sauce" => 10}
    actual_2 = @pantry.shopping_list

    assert_equal expected_2, actual_2
  end

  def test_it_can_print_shopping_list
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Cheese", 20)
    r.add_ingredient("Flour", 20)
    @pantry.add_to_shopping_list(r)

    r = Recipe.new("Spaghetti")
    r.add_ingredient("Spaghetti Noodles", 10)
    r.add_ingredient("Marinara Sauce", 10)
    r.add_ingredient("Cheese", 5)
    @pantry.add_to_shopping_list(r)

    expected = "* Cheese: 25\n* Flour: 20\n* Spaghetti Noodles: 10\n* Marinara Sauce: 10"
    actual = @pantry.print_shopping_list

    assert_equal expected, actual
  end

  def test_it_can_add_recipes_to_cook_book


    @pantry.add_to_cookbook(@r1)
    @pantry.add_to_cookbook(@r2)
    @pantry.add_to_cookbook(@r3)

    assert_equal 3, @pantry.cookbook.count
  end

  def test_it_will_recommend_recipes
    @pantry.add_to_cookbook(@r1)
    @pantry.add_to_cookbook(@r2)
    @pantry.add_to_cookbook(@r3)

    @pantry.restock("Cheese", 10)
    @pantry.restock("Flour", 20)
    @pantry.restock("Brine", 40)
    @pantry.restock("Cucumbers", 120)
    @pantry.restock("Raw nuts", 20)
    @pantry.restock("Salt", 20)

    expected = ["Pickles", "Peanuts"]
    actual = @pantry.what_can_i_make
    assert_equal expected, actual
  end

  def test_it_returns_how_many_of_a_recipe_I_can_make
    @pantry.add_to_cookbook(@r1)
    @pantry.add_to_cookbook(@r2)
    @pantry.add_to_cookbook(@r3)

    @pantry.restock("Cheese", 10)
    @pantry.restock("Flour", 20)
    @pantry.restock("Brine", 40)
    @pantry.restock("Cucumbers", 120)
    @pantry.restock("Raw nuts", 20)
    @pantry.restock("Salt", 20)

    expected = {"Pickles" => 4, "Peanuts" => 2}
    actual = @pantry.how_many_can_i_make
    assert_equal expected, actual
  end

  def test_list_check
    assert_equal 0, @pantry.list_check("Cheese")
  end

  def test_shopping_list_adds_more_to_itself
    assert_equal 0, @pantry.list_check("Cheese")
    @pantry.add_to_shopping_list_helper("Cheese", 15)
    assert_equal 15, @pantry.list_check("Cheese")
  end

  def test_I_can_get_an_array_of_how_many_I_can_make
    @pantry.add_to_cookbook(@r1)
    @pantry.add_to_cookbook(@r2)
    @pantry.add_to_cookbook(@r3)

    @pantry.restock("Cheese", 10)
    @pantry.restock("Flour", 20)
    @pantry.restock("Brine", 40)
    @pantry.restock("Cucumbers", 120)
    @pantry.restock("Raw nuts", 20)
    @pantry.restock("Salt", 20)

    assert_equal [4,2], @pantry.how_many_can_i_make_helper
  end
end
