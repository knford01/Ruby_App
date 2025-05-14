class AddOrderNumberAndTotalPriceToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :order_number, :string
    add_column :orders, :total_price, :decimal, precision: 10, scale: 2
  end
end
