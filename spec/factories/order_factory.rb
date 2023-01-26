FactoryBot.define do
  factory(:order) do
    not_included_ingredients { [Ingredient.last] }
  end
end