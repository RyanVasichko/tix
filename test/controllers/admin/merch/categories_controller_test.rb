require "test_helper"

class Admin::Merch::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @food_merch_category = merch_categories(:food)
  end

  test "should get index" do
    get admin_merch_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_merch_category_url
    assert_response :success
  end

  test "should create merch category" do
    assert_difference("Merch::Category.count") do
      post admin_merch_categories_url, params: { merch_category: { name: "Clothing" } }
    end

    assert_redirected_to admin_merch_categories_url
  end

  test "should get edit" do
    get edit_admin_merch_category_url(@food_merch_category)
    assert_response :success
  end

  test "should update merch category" do
    patch admin_merch_category_url(@food_merch_category), params: { merch_category: { name: "Updated name" } }
    assert_redirected_to admin_merch_categories_url
  end

  test "should destroy merch category" do
    assert_difference("Merch::Category.count", -1) do
      assert_difference("Merch.count", 0) do
        delete admin_merch_category_url(@food_merch_category)
      end
    end

    assert_redirected_to admin_merch_categories_url
  end
end
