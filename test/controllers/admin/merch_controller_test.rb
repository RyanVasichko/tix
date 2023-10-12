require "application_integration_test_case"

class Admin::MerchControllerTest < ApplicationIntegrationTestCase
  setup do
    log_in_as(users(:larry_sellers), "password")
    @bbq_sauce_merch = merch(:bbq_sauce)
  end

  test "should get index" do
    get admin_merch_index_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_merch_url
    assert_response :success
  end

  test "should create merch" do
    assert_difference("Merch.count") do
      image = fixture_file_upload(Rails.root.join("test", "fixtures", "files", "coffee.jpg"), "image/jpg")
      post admin_merch_index_url,
           params: {
             merch: {
               name: "Coffee",
               description: "Specialty coffee",
               price: 13.37,
               image: image,
               category_ids: [merch_categories(:coffee).id, merch_categories(:food).id],
               categories_attributes: {
                "0" => { name: "Gift Cards" },
                "1" => { name: "" }
               }
             }
           }
    end
    
    assert_redirected_to admin_merch_index_url

    @merch = Merch.last
    @gift_card_category = Merch::Category.find_by!(name: "Gift Cards")

    assert_equal "Coffee", @merch.name
    assert_equal "Specialty coffee", @merch.description
    assert_equal 13.37, @merch.price
    assert_equal 3, @merch.categories.length

    assert @merch.categories.include?(merch_categories(:coffee))
    assert @merch.categories.include?(merch_categories(:food))
    assert @merch.categories.include?(@gift_card_category)

  end

  test "should get edit" do
    get edit_admin_merch_url(@bbq_sauce_merch)
    assert_response :success
  end

  test "should update merch" do
    image = fixture_file_upload(Rails.root.join("test", "fixtures", "files", "coffee.jpg"), "image/jpg")
    patch admin_merch_url(@bbq_sauce_merch),
          params: {
            merch: {
              name: "Updated name",
              description: "Updated description",
              price: 0.01,
              image: image,
              category_ids: [merch_categories(:coffee).id]
            }
          }

    assert_equal "Updated name", @bbq_sauce_merch.reload.name
    assert_equal "Updated description", @bbq_sauce_merch.description
    assert_equal 0.01, @bbq_sauce_merch.price
    assert @bbq_sauce_merch.image.attached?
    assert_equal "coffee.jpg", @bbq_sauce_merch.image.filename.to_s

    assert_equal 1, @bbq_sauce_merch.categories.length
    assert_equal merch_categories(:coffee), @bbq_sauce_merch.categories.first
  end

  test "should destroy merch" do
    skip "How to handle destroying merch?"
    assert_difference("Merch.count", -1) { delete admin_merch_url(@bbq_sauce_merch) }

    assert_redirected_to admin_merch_index_url
  end
end
