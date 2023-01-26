require "rails_helper"

RSpec.describe OrderController, type: :controller do
  Faker::UniqueGenerator.clear

  describe 'success add_order' do
    let!(:dish) { create :dish, :with_ingredient }
    let!(:dish2) { create :dish, :with_ingredient }

    context 'send params' do
      before do
        put 'add_order', params: { order: { not_included_ingredients: dish2.ingredients.ids } }
      end

      it 'add flash message' do
        expect(flash[:messages]).to be_present
        expect(flash[:messages][:class]).to eq 'success'
      end

      it 'redirect to root' do
        expect(response).to redirect_to(root_path)
      end

      it 'returns status code 302' do
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'fail add_order' do
    let!(:dish) { create :dish, :with_ingredient }

    context 'send params' do
      before do
        put 'add_order', params: { order: { not_included_ingredients: dish.ingredients.ids } }
      end

      it 'add flash message' do
        expect(flash[:messages]).to be_present
        expect(flash[:messages][:class]).to eq 'error'
      end

      it 'redirect to root' do
        expect(response).to redirect_to(root_path)
      end

      it 'returns status code 302' do
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'ordered_dishes' do
    let!(:dish) { create :dish, :with_ingredient }
    let!(:dish2) { create :dish, :with_ingredient }
    let!(:order) { create :order }
    let!(:order2) { create :order, created_at: Date.new(2022, 1, 1), not_included_ingredients: dish.ingredients.ids }

    context 'check page ordered_dishes' do
      before do
        get 'ordered_dishes'
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'must be JSON' do
        expect(response.content_type).to start_with('application/json')
      end

      it 'must contain json data' do
        expect(response.body).to eq(Order.total_dish.map { |v| { name: v.name, count: v.counts } }.to_json)
      end
    end

    context 'check page ordered_dishes_by_date' do
      before do
        get 'ordered_dishes_by_date', params: { date: '2022-01-01' }
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'must be JSON' do
        expect(response.content_type).to start_with('application/json')
      end

      it 'must contain json data' do
        expect(response.body).to eq(Order.total_dish_by_date(Date.strptime('2022-01-01', '%Y-%m-%d'))
                                         .map { |v| { name: v.name, count: v.counts } }.to_json)
      end
    end

    context 'check page order_by_id' do
      before do
        get 'order_by_id', params: { id: order2.id }
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'must be JSON' do
        expect(response.content_type).to start_with('application/json')
      end

      it 'must contain json data' do
        expect(response.body).to eq(Order.where(id: order2.id).total_dish.map { |v| { name: v.name, count: v.counts } }.to_json)
      end
    end
  end
end