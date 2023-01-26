require 'rails_helper'

RSpec.describe 'Ingredient model', type: :model do
  Faker::UniqueGenerator.clear
  context 'must return all dishes included this ingredient' do
    let(:ingredient) { create :ingredient, name: 'соль' }
    let(:dish) { create :dish, name: 'соль с ничем', ingredients: [ingredient] }

    it('should return dish') { expect(ingredient.dishes).to contain_exactly(dish) }
  end
end