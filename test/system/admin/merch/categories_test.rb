require "application_system_test_case"

class Admin::Merch::CategoriesTest < ApplicationSystemTestCase
  setup do
    log_in_as FactoryBot.create(:admin), "password"
    @merch_category = FactoryBot.create(:merch_category)
  end

  test "visiting the index" do
    visit admin_merch_categories_url

    assert_text "Categories"
    assert_text @merch_category.name
  end

  test "should create category" do
    visit admin_merch_categories_url
    click_on "New Category"
    fill_in "Name", with: "New Category Name"
    click_on "Create Category"

    assert_text "Category was successfully created"
    assert Merch::Category.exists?(name: "New Category Name")
  end

  test "should update category" do
    visit admin_merch_categories_url
    click_on @merch_category.name
    fill_in "Name", with: "Updated Category Name"
    click_on "Update Category"

    assert_text "Category was successfully updated"
    assert_equal "Updated Category Name", @merch_category.reload.name
  end

  test "should destroy category" do
    visit admin_merch_categories_url
    find("##{dom_id(@merch_category, :admin)}_dropdown").click
    click_on "Delete"

    assert_text "Category was successfully destroyed"
  end
end
