require 'rails_helper'

RSpec.describe 'Orders model', type: :model do
  before do
    Faker::UniqueGenerator.clear
    create :dish, :with_ingredient
  end
  context 'private methods' do
    let(:order) { build :order, not_included_ingredients: [nil, 99, 45] }

    it '#clear_null_values' do
      expect(order.send(:clear_null_values)).to eq([99, 45])
    end

    describe '#check_dish_count' do
      it 'should return nil if have dish' do
        expect(order.send(:check_dish_count)).to eq(nil)
      end

      it 'should return error if no dish in order' do
        order.not_included_ingredients = Dish.last.ingredients.ids
        expect(order.send(:check_dish_count)).to be_a(ActiveModel::Error)
      end
    end

  end

  context 'instance methods' do
    let(:order) { build :order, not_included_ingredients: [nil, 99, 45] }
    describe '#dishes' do
      it 'should return collection of dishes' do
        expect(order.dishes).to be_a(ActiveRecord::Relation)
        expect(order.dishes.count).to be > 0
      end
    end
  end

  context 'scopes' do
    let!(:dish) { create :dish, :with_ingredient }
    let!(:order) { create :order, not_included_ingredients: [nil, 99, 45] }
    let!(:order2) { create :order, created_at: Date.new(2022, 1, 1), not_included_ingredients: dish.ingredients.ids }

    describe ':total_dish' do
      it 'should return total dishes of all time' do
        expect(Order.total_dish.length).to be 2
      end
    end

    describe '#total_dish_by_date' do
      it 'should return total dishes for date 2022.01.01' do
        expect(Order.total_dish_by_date(Date.new(2022, 1, 1)).length).to be 1
      end
    end
  end
end