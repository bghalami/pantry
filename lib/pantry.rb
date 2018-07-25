require "pry"
class Pantry

  attr_accessor :stock,
                :shopping_list,
                :cookbook

  def initialize
    @stock = {}
    @shopping_list = {}
    @cookbook = {}
  end

  def stock_check(item)
    if @stock[item]
      @stock[item]
    else
      0
    end
  end

  def restock(item, count)
    @stock[item] = stock_check(item) + count
  end

  def list_check(item)
    if @shopping_list[item]
      @shopping_list[item]
    else
      0
    end
  end

  def add_to_shopping_list_helper(item, count)
    @shopping_list[item] = list_check(item) + count
  end

  def add_to_shopping_list(recipe)
    recipe.ingredients.each do |ingredient, amount|
      add_to_shopping_list_helper(ingredient, amount)
    end
  end

  def print_shopping_list
    printed_list = @shopping_list.map do |ingredient, amount|
      "* #{ingredient}: #{amount}\n"
    end
    (printed_list.join).strip
  end

  def add_to_cookbook(recipe)
    @cookbook[recipe.name] = recipe.ingredients
  end

  def what_can_i_make
    can_make = cookbook.map do |recipe|
      if recipe[1].all? do |ingredient, amount|
          stock_check(ingredient) >= amount
        end
        recipe[0]
      end
    end
    can_make.compact
  end

  def how_many_can_i_make_helper
    array = []
    can_make = what_can_i_make.map do |recipe|
      @cookbook[recipe].each do |ingredient, amount|
        array << stock_check(ingredient) / amount
      end
    end
    array.uniq
  end

  def how_many_can_i_make
    what = what_can_i_make
    amount = how_many_can_i_make_helper
    Hash[what.zip(amount)]
  end

end
