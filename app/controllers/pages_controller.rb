class PagesController < ApplicationController
  def index
    @ingredients = Ingredient.all
    @dishes = Dish.includes(:ingredients).all
  end
end
