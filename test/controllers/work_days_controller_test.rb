require "test_helper"

class WorkDaysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get work_days_index_url
    assert_response :success
  end

  test "should get show" do
    get work_days_show_url
    assert_response :success
  end

  test "should get new" do
    get work_days_new_url
    assert_response :success
  end

  test "should get create" do
    get work_days_create_url
    assert_response :success
  end

  test "should get destroy" do
    get work_days_destroy_url
    assert_response :success
  end
end
