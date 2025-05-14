class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :shopify_order_id
      t.string :customer_name
      t.string :status
      t.string :tracking_number
      t.date :ship_date
      t.json :order_data

      t.timestamps
    end
  end
end
