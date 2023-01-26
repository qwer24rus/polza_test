class CreateDishes < ActiveRecord::Migration[7.0]
  def change
    create_table :dishes do |t|
      t.string :name, null: false
    end

    create_table :dishes_ingredients do |t|
      t.belongs_to :dish
      t.belongs_to :ingredient
    end

  end
end
