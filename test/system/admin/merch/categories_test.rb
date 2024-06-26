require "application_system_test_case"

class Admin::Merch::CategoriesTest < ApplicationSystemTestCase
  setup do
    sign_in FactoryBot.create(:admin)
    @merch_category = FactoryBot.create(:merch_category)
  end

  test "visiting the index" do
    visit admin_merch_index_url
    click_on "Categories"

    assert_text "Categories"
    assert_text @merch_category.name
  end

  test "should create category" do
    visit admin_merch_index_url
    click_on "Categories"

    find("#new_merch_category").click
    fill_in "Name", with: "New Category Name"
    click_on "Create Category"

    assert_text "Merch category was successfully created"
    assert Merch::Category.exists?(name: "New Category Name")
  end

  test "should update category" do
    visit admin_merch_index_url
    click_on "Categories"

    click_on @merch_category.name
    fill_in "Name", with: "Updated Category Name"
    click_on "Update Category"

    assert_text "Merch category was successfully updated"
    assert_equal "Updated Category Name", @merch_category.reload.name
  end

  test "should destroy category" do
    visit admin_merch_index_url
    click_on "Categories"

    within "tr", text: @merch_category.name do
      click_on "Delete"
    end

    assert_text "Merch category was successfully destroyed"
  end
end
