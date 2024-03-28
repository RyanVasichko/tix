require "test_helper"

class MerchControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category1 = FactoryBot.create(:merch_category)
    @category2 = FactoryBot.create(:merch_category)

    @merch1 = FactoryBot.create(:merch, categories: [@category1])
    @merch2 = FactoryBot.create(:merch, categories: [@category2])

    @inactive_merch = FactoryBot.create(:merch, active: false, categories: [@category1])
  end

  test "should get index and display all active merch items when 'all' is selected" do
    get merch_index_url, params: { merch_category_id: ['all'] }
    assert_response :success
    assert_includes @response.body, @merch1.name
    assert_includes @response.body, @merch2.name
    assert_not_includes @response.body, @inactive_merch.name
  end

  test "should filter by category when a specific category is selected" do
    get merch_index_url, params: { merch_category_id: [@category1.id] }
    assert_response :success
    assert_includes @response.body, @merch1.name
    assert_not_includes @response.body, @merch2.name
  end

  test "should handle empty search parameters gracefully" do
    get merch_index_url
    assert_response :success
    assert_includes @response.body, @merch1.name
    assert_includes @response.body, @merch2.name
  end
end
