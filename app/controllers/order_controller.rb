class OrderController < ApplicationController
  layout false

  def add_order
    order = Order.new(permitted_params)
    flash[:messages] = if order.save
                         { class: 'success', title: I18n.t('messages.title.success'),
                           text: [I18n.t('messages.text.order_placed')] }
                       else
                         { class: 'error', title: I18n.t('messages.title.error'), text: order.errors.full_messages }
                       end
    redirect_to root_path
  end

  def ordered_dishes
    render json: Order.total_dish.map { |v| { name: v.name, count: v.counts } }
  end

  def ordered_dishes_by_date
    render json: Order.total_dish_by_date(Date.strptime(params[:date], '%Y-%m-%d'))
                      .map { |v| { name: v.name, count: v.counts } }
  end

  def order_by_id
    render json: Order.where(id: params[:id]).total_dish.map { |v| { name: v.name, count: v.counts } }
  end

  private

  def permitted_params
    params.require(:order).permit(not_included_ingredients: [])
  end
end
