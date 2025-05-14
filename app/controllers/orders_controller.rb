require 'shopify_api'

class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :mark_delivered]

  def index
    @orders = Order.where(status: "new")
  end

  def show
    @order = Order.find(params[:id])
  end

  def shipped
    @orders = Order.where(status: "shipped")
  end

  def delivered
    @orders = Order.where(status: "delivered")
  end

  def import
    client = ShopifyAPI::Clients::Rest::Admin.new(
      session: ShopifyAPI::Auth::Session.new(
        shop: ENV["SHOPIFY_SHOP_DOMAIN"],
        access_token: ENV["SHOPIFY_ADMIN_TOKEN"]
      )
    )

    response = client.get(path: "orders", query: {
      fulfillment_status: "unfulfilled",
      status: "open"
    })

    # Rails.logger.info "=== Shopify Orders Response ==="
    # Rails.logger.info response.body.to_json

    imported_count = 0

    response.body["orders"].each do |shopify_order|
      next if Order.exists?(shopify_order_id: shopify_order["id"])

      Order.create!(
        shopify_order_id: shopify_order["id"],
        order_number: shopify_order["order_number"],
        customer_name: shopify_order["customer"]["id"],
        total_price: shopify_order["total_price"],
        status: "new",
        order_data: shopify_order["line_items"]
      )

      imported_count += 1
    end

    redirect_to orders_path, notice: "#{imported_count} order(s) imported successfully."
  rescue => e
    Rails.logger.error("Shopify Import Failed: #{e.message}")
    redirect_to orders_path, alert: "Failed to import orders from Shopify."
  end

  def update
    if @order.update(order_params.merge(status: "shipped"))
      update_shopify_fulfillment(@order)
      redirect_to shipped_orders_path, notice: "Order marked as shipped and updated in Shopify."
    else
      render :show, alert: "Failed to update order."
    end
  end

  def mark_delivered
    if @order.update(status: "delivered")
      redirect_to delivered_orders_path, notice: "Order marked as delivered."
    else
      redirect_to shipped_orders_path, alert: "Failed to mark order as delivered."
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:tracking_number, :ship_date)
  end

  def update_shopify_fulfillment(order)
    Rails.logger.info "=== Shopify Order ==="
    Rails.logger.info order.shopify_order_id

    session = ShopifyAPI::Auth::Session.new(
      shop: ENV["SHOPIFY_SHOP_DOMAIN"],
      access_token: ENV["SHOPIFY_ADMIN_TOKEN"]
    )

    # 1. Get fulfillment orders
    response = ShopifyAPI::Clients::Rest::Admin.new(session: session).get(
      path: "orders/#{order.shopify_order_id}/fulfillment_orders.json",
      query: { status: "open" }
    )

    Rails.logger.info "=== Shopify Fulfillment Response ==="
    Rails.logger.info response.body.to_json

    fulfillment_orders = response.body["fulfillment_orders"]
    raise "No fulfillment orders found" if fulfillment_orders.empty?

    # Rails.logger.info "=== Shopify Fulfillment Info ==="
    # Rails.logger.info fulfillment_orders.body.to_json

    fulfillment_order_id = fulfillment_orders.first["id"]

    # 2. Create the fulfillment
    fulfillment_payload = {
      fulfillment: {
        message: "Order shipped via Ruby App",
        notify_customer: true,
        tracking_info: {
          number: order.tracking_number,
          company: "Other"
        },
        fulfillment_order_id: fulfillment_order_id
      }
    }

    ShopifyAPI::Clients::Rest::Admin.new(session: session).post(
      path: "fulfillments.json",
      body: fulfillment_payload
    )
  rescue => e
    Rails.logger.error("Shopify fulfillment failed: #{e.message}")
  end

end
