require "rails_helper"

RSpec.describe PagesController, type: :controller do
  describe 'index' do
    let!(:dish) { create :dish, :with_ingredient }
    let!(:dish2) { create :dish, :with_ingredient }

    it 'should have list of dishes' do
      get :index

      expect(assigns(:dishes).count).to be 2
      expect([dish, dish2]).to eq(assigns(:dishes))
    end

    it 'should have list of ingredients' do
      get :index

      expect(assigns(:ingredients).count).to be dish.ingredients.count + dish2.ingredients.count
      expect(Ingredient.all).to eq(assigns(:ingredients))
    end

    it 'renders right template' do
      get :index
      expect(response).to render_template('pages/index')
    end
  end
end
