require 'rails_helper'

RSpec.describe 'Root page', type: :feature, js: true do
  before do
    # we create 2 dish
    # first have 2 ingredients
    # second have one ingredient same as included in first
    Faker::UniqueGenerator.clear
    create :dish, :with_ingredient
    create :dish, ingredients: [Ingredient.last]
  end

  describe 'visit root page' do
    before do
      visit root_path
    end

    it 'should have title' do
      title = page.find('h1')
      expect(title.text).to eq(I18n.t('pages.index.title'))
    end

    it 'should have 2 ingredients' do
      expect(page).to have_selector('div.ingredient', count: 2)
    end

    it 'should have 2 dishes' do
      expect(page).to have_selector('div.single_product', count: 2)
    end

    it 'should hide one dish on click' do
      page.check("order_not_included_ingredients_#{Ingredient.first.id}")
      expect(page).to have_selector('div.single_product', count: 1)
    end

    it 'should hide 0 dishes on click both ingredient' do
      page.check("order_not_included_ingredients_#{Ingredient.first.id}")
      page.check("order_not_included_ingredients_#{Ingredient.last.id}")
      expect(page).to have_selector('div.single_product', count: 0)
    end

    it 'should show hidden dishes' do
      page.check("order_not_included_ingredients_#{Ingredient.first.id}")
      expect(page).to have_selector('div.single_product', count: 1)

      page.uncheck("order_not_included_ingredients_#{Ingredient.first.id}")
      expect(page).to have_selector('div.single_product', count: 2)
    end

  end

  describe 'make an order' do
    before do
      visit root_path
    end

    it 'submit form with 2 dishes' do
      page.find('input[type="submit"]').click
      note_message = page.find('div.note_message')

      expect(page).to have_selector('div.note_message', count: 1)

      expect(note_message).to have_text(I18n.t('messages.title.success'))

      expect(Order.all.count).to eq 1

      expect(Order.last.dishes.count).to eq 2

    end

    it 'submit form without any dishes' do

      page.check("order_not_included_ingredients_#{Ingredient.last.id}")

      page.find('input[type="submit"]').click
      note_message = page.find('div.note_message')

      expect(page).to have_selector('div.note_message', count: 1)

      expect(note_message).to have_text(I18n.t('messages.title.error'))

      expect(Order.all.count).to eq 0
    end
  end
end