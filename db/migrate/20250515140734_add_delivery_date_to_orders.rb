class AddDeliveryDateToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :delivery_date, :date
  end
end
