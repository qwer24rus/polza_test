FactoryBot.define do
  factory(:dish) do
    name { Faker::Food.unique.dish }

    transient do
      association :ingredients
    end

    trait :with_ingredient do
      ingredients { create_list(:ingredient, 2) }
    end
  end
end