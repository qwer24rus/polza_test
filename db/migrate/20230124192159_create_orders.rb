class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :not_included_ingredients, array: true, default: [], null: false
      t.timestamps
    end
  end
end
