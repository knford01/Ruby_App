ShopifyAPI::Context.setup(
  api_key: ENV["SHOPIFY_API_KEY"],
  api_secret_key: ENV["SHOPIFY_API_SECRET"],
  api_version: "2022-10", # or the version you're using
  host_name: "localhost", # replace with your actual hostname in prod
  is_private: true,
  is_embedded: false,
  scope: "read_orders,write_orders,read_fulfillments,write_fulfillments,read_assigned_fulfillment_orders,write_assigned_fulfillment_orders",
  session_storage: ShopifyAPI::Auth::FileSessionStorage.new
)

