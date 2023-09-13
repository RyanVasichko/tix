require "test_helper"

class Admin::ShowsControllerTest < ActionDispatch::IntegrationTest
  setup do
    skip "for now"
    @admin_show = admin_shows(:one)
  end

  test "should get index" do
    get admin_shows_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_show_url
    assert_response :success
  end

  test "should create admin_show" do
    assert_difference("Show.count") do
      post admin_shows_url, params: { admin_show: {  } }
    end

    assert_redirected_to admin_show_url(Show.last)
  end

  test "should show admin_show" do
    get admin_show_url(@admin_show)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_show_url(@admin_show)
    assert_response :success
  end

  test "should update admin_show" do
    patch admin_show_url(@admin_show), params: { admin_show: {  } }
    assert_redirected_to admin_show_url(@admin_show)
  end

  test "should destroy admin_show" do
    assert_difference("Show.count", -1) do
      delete admin_show_url(@admin_show)
    end

    assert_redirected_to admin_shows_url
  end
end
