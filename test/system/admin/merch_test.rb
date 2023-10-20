require "application_system_test_case"

class Admin::MerchTest < ApplicationSystemTestCase
  setup do
    log_in_as FactoryBot.create(:admin), "password"
    @merch = FactoryBot.create(:merch)
  end

  test "visiting the index" do
    visit admin_merch_index_url
    assert_text "Merch"
    assert_text @merch.name
  end

  test "should create merch" do
    merch_category = FactoryBot.create(:merch_category)
    assert_difference("Merch.count") do
      visit admin_merch_index_url
      click_on "New Merch"

      fill_in "Name", with: "Coffee"
      fill_in "Price", with: 10
      fill_in "Description", with: "Coffee Description"
      attach_file "merch_image", Rails.root.join("test/fixtures/files/coffee.jpg")

      click_on "Add Category"
      fill_in "Category name", with: "Test new category"

      check merch_category.name

      click_on "Create Merch"

      assert_text "Merch was successfully created"
    end

    coffee = Merch.last
    new_category = Merch::Category.find_by!(name: "Test new category")

    assert_equal "Coffee", coffee.name
    assert_equal 10, coffee.price
    assert_equal "Coffee Description", coffee.description
    assert_equal "coffee.jpg", coffee.image.filename.to_s

    assert_equal 2, coffee.categories.length
    assert coffee.categories.include?(merch_category)
    assert coffee.categories.include?(new_category)
  end

  test "should update Merch" do
    FactoryBot.create(:merch_category, name: "Food")
    coffee = FactoryBot.create(:merch_category, name: "Coffee")

    visit admin_merch_index_url
    click_on @merch.name

    fill_in "Name", with: "Updated Name"
    fill_in "Price", with: 20
    fill_in "Description", with: "Updated Description"
    attach_file "merch_image", Rails.root.join("test/fixtures/files/coffee.jpg")

    uncheck "Food"
    check "Coffee"

    click_on "Add Category"
    fill_in "Category name", with: "Test new category"

    click_on "Update Merch"

    assert_text "Merch was successfully updated"

    new_category = Merch::Category.find_by!(name: "Test new category")

    assert_equal "Updated Name", @merch.reload.name
    assert_equal 20, @merch.reload.price
    assert_equal "Updated Description", @merch.reload.description
    assert_equal "coffee.jpg", @merch.reload.image.filename.to_s

    assert_equal 2, @merch.categories.length
    assert @merch.categories.include?(coffee)
    assert @merch.categories.include?(new_category)
  end

  test "should take merch off sale" do
    visit admin_merch_index_url

    find("#admin_merch_#{@merch.id}_dropdown").click
    click_on "Take off sale"

    assert_text "Merch was taken off sale"
    refute @merch.reload.active?
  end

  test "should put merch on sale" do
    @merch.deactivate!
    visit admin_merch_index_url
    check "Show off sale"

    find("#admin_merch_#{@merch.id}_dropdown").click
    click_on "Put on sale"

    assert_text "Merch was put on sale"
    assert @merch.reload.active?
  end
end
