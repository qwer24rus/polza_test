require 'rails_helper'

RSpec.describe 'Dish Model', type: :model do
  Faker::UniqueGenerator.clear
  context 'must return all ingredients included this dish' do
    let(:ingredient) { create :ingredient, name: 'соль' }
    let(:dish) { create :dish, name: 'соль с ничем', ingredients: [ingredient] }

    it('should return dish') { expect(dish.ingredients).to contain_exactly(ingredient) }
  end

  context 'should return dish without exclusive ingredients' do
    let(:ingredient) { create :ingredient, name: 'соль' }
    let(:ingredient2) { create :ingredient, name: 'масло' }
    let(:dish) { create :dish, name: 'соль с ничем', ingredients: [ingredient] }
    let(:dish2) { create :dish, name: 'соль с маслом', ingredients: [ingredient, ingredient2] }

    it 'should return only one dish' do
      expect(Dish.without_ingredients(ingredient2.id)).to contain_exactly(dish)
    end

    it 'should return 0 dishes' do
      expect(Dish.without_ingredients([ingredient2.id, ingredient.id]).count).to be 0
    end

  end
end
