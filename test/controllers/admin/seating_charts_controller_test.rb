require "test_helper"

class Admin::SeatingChartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_seating_chart = admin_seating_charts(:one)
  end

  test "should get index" do
    get admin_seating_charts_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_seating_chart_url
    assert_response :success
  end

  test "should create admin_seating_chart" do
    assert_difference("Admin::SeatingChart.count") do
      post admin_seating_charts_url, params: { admin_seating_chart: {  } }
    end

    assert_redirected_to admin_seating_chart_url(Admin::SeatingChart.last)
  end

  test "should show admin_seating_chart" do
    get admin_seating_chart_url(@admin_seating_chart)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_seating_chart_url(@admin_seating_chart)
    assert_response :success
  end

  test "should update admin_seating_chart" do
    patch admin_seating_chart_url(@admin_seating_chart), params: { admin_seating_chart: {  } }
    assert_redirected_to admin_seating_chart_url(@admin_seating_chart)
  end

  test "should destroy admin_seating_chart" do
    assert_difference("Admin::SeatingChart.count", -1) do
      delete admin_seating_chart_url(@admin_seating_chart)
    end

    assert_redirected_to admin_seating_charts_url
  end
end
