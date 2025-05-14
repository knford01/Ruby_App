require "test_helper"

class WorkEntriesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get work_entries_new_url
    assert_response :success
  end

  test "should get create" do
    get work_entries_create_url
    assert_response :success
  end
end
