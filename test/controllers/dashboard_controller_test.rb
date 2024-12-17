require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get calendar" do
    get dashboard_calendar_url
    assert_response :success
  end
end
