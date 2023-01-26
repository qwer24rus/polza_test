class Ingredient < ApplicationRecord
  has_and_belongs_to_many :dishes
  validates :name, uniqueness: true

end
