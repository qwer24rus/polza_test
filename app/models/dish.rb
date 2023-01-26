class Dish < ApplicationRecord
  has_and_belongs_to_many :ingredients

  validates :ingredients, length: { minimum: 1 }
  validates :name, uniqueness: true

  scope :without_ingredients, lambda { |ingredients|
    where('id NOT IN (SELECT "dish_id" FROM "dishes_ingredients" WHERE "ingredient_id" IN (?) )', ingredients)
  }

end
