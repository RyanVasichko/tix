require "test_helper"

class Admin::MerchControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in FactoryBot.create(:admin)
    @merch = FactoryBot.create(:merch)
    @merch_category_1 = FactoryBot.create(:merch_category)
    @merch_category_2 = FactoryBot.create(:merch_category)
  end

  test "should get index" do
    get admin_merch_index_url
    assert_response :success

    assert_includes response.body, @merch.name
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
               category_ids: [@merch_category_1.id, @merch_category_2.id],
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

    assert @merch.categories.include?(@merch_category_1)
    assert @merch.categories.include?(@merch_category_2)
    assert @merch.categories.include?(@gift_card_category)
  end

  test "should get edit" do
    get edit_admin_merch_url(@merch)
    assert_response :success
  end

  test "should update merch" do
    image = fixture_file_upload(Rails.root.join("test", "fixtures", "files", "coffee.jpg"), "image/jpg")
    patch admin_merch_url(@merch),
          params: {
            merch: {
              name: "Updated name",
              description: "Updated description",
              price: 0.01,
              image: image,
              category_ids: [@merch_category_1.id]
            }
          }

    assert_equal "Updated name", @merch.reload.name
    assert_equal "Updated description", @merch.description
    assert_equal 0.01, @merch.price
    assert @merch.image.attached?
    assert_equal "coffee.jpg", @merch.image.filename.to_s

    assert_equal 1, @merch.categories.length
    assert_equal @merch_category_1, @merch.categories.first
  end

  test "should destroy merch" do
    skip "How to handle destroying merch?"
    assert_difference("Merch.count", -1) { delete admin_merch_url(@merch) }

    assert_redirected_to admin_merch_index_url
  end
end
