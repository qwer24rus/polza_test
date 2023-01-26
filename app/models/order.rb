class Order < ApplicationRecord
  before_save :clear_null_values

  scope :total_dish, lambda {
    select('dishes.name, COUNT(dishes.id) AS counts')
      .joins('JOIN dishes ON dishes.id NOT IN (
          SELECT dishes_ingredients.dish_id FROM dishes_ingredients WHERE dishes_ingredients.ingredient_id = ANY(orders.not_included_ingredients))')
      .group('dishes.id').order(counts: :desc)
  }
  scope :total_dish_by_date, lambda { |date|
    total_dish.where('orders.created_at::date = ?', date)
  }

  validate :check_dish_count

  def dishes
    Dish.without_ingredients(not_included_ingredients)
  end

  private

  def clear_null_values
    self.not_included_ingredients = self.not_included_ingredients.compact
  end

  def check_dish_count
    return if dishes.count.positive?

    errors.add(:base, I18n.t('activerecord.errors.models.orders.attributes.dish_count_invalid'))
  end
end
