require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "should get dream_journal" do
    get home_dream_journal_url
    assert_response :success
  end

  test "should get work_journal" do
    get home_work_journal_url
    assert_response :success
  end

  test "should get order_fulfillment" do
    get home_order_fulfillment_url
    assert_response :success
  end
end
