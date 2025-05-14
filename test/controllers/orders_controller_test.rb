require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get orders_index_url
    assert_response :success
  end

  test "should get show" do
    get orders_show_url
    assert_response :success
  end

  test "should get shipped" do
    get orders_shipped_url
    assert_response :success
  end

  test "should get delivered" do
    get orders_delivered_url
    assert_response :success
  end

  test "should get update" do
    get orders_update_url
    assert_response :success
  end

  test "should get mark_delivered" do
    get orders_mark_delivered_url
    assert_response :success
  end
end
