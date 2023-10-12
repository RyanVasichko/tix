require "application_system_test_case"

class Admin::MerchTest < ApplicationSystemTestCase
  setup do
    log_in_as users(:larry_sellers), "password"
    @bbq_sauce_merch = merch(:bbq_sauce)
  end

  test "visiting the index" do
    visit admin_merch_index_url
    assert_text "Merch"
    assert_text "BBQ Sauce"
  end

  test "should create merch" do
    assert_difference("Merch.count") do
      visit admin_merch_index_url
      click_on "New Merch"

      fill_in "Name", with: "Coffee"
      fill_in "Price", with: 10
      fill_in "Description", with: "Coffee Description"
      attach_file "merch_image", Rails.root.join("test/fixtures/files/coffee.jpg")

      click_on "Add Category"
      fill_in "Category name", with: "Test new category"

      check merch_categories(:coffee).name

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
    assert coffee.categories.include?(merch_categories(:coffee))
    assert coffee.categories.include?(new_category)
  end

  test "should update Merch" do
    visit admin_merch_index_url
    click_on @bbq_sauce_merch.name

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

    assert_equal "Updated Name", @bbq_sauce_merch.reload.name
    assert_equal 20, @bbq_sauce_merch.reload.price
    assert_equal "Updated Description", @bbq_sauce_merch.reload.description
    assert_equal "coffee.jpg", @bbq_sauce_merch.reload.image.filename.to_s

    assert_equal 2, @bbq_sauce_merch.categories.length
    assert @bbq_sauce_merch.categories.include?(merch_categories(:coffee))
    assert @bbq_sauce_merch.categories.include?(new_category)
  end

  test "should take merch off sale" do
    visit admin_merch_index_url

    find("#admin_merch_#{@bbq_sauce_merch.id}_dropdown").click
    click_on "Take off sale"

    assert_text "Merch was taken off sale"
    refute @bbq_sauce_merch.reload.active?
  end

  test "should put merch on sale" do
    @bbq_sauce_merch.deactivate!
    visit admin_merch_index_url
    check "Show off sale"

    find("#admin_merch_#{@bbq_sauce_merch.id}_dropdown").click
    click_on "Put on sale"

    assert_text "Merch was put on sale"
    assert @bbq_sauce_merch.reload.active?
  end
end
