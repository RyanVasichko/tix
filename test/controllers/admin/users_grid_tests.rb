module Admin::UsersGridTests
  extend ActiveSupport::Concern

  included do
    setup do
      FactoryBot.create user_factory_name,
                        first_name: "Sylvio",
                        last_name: "Dante",
                        email: "Sylvio.Dante@example.com",
                        phone: "(987) 654-3210"

      FactoryBot.create user_factory_name,
                        first_name: "Paulie",
                        last_name: "Gaultieri",
                        email: "paulie_gaulteri@test.com",
                        phone: "123-456-7890"
    end

    test "should get index" do
      get index_url
      assert_response :success
      assert_includes response.body, "Sylvio Dante"
      assert_includes response.body, "Paulie Gaultieri"
      assert_select "tbody tr", count: 2
    end

    test "index should be keyword searchable by name" do
      get index_url(q: "paul")
      assert_response :success
      assert_select "tbody tr:first-child td", text: "Paulie Gaultieri"
      assert_select "tbody tr", count: 1
    end

    test "index should be keyword searchable by email" do
      get index_url(q: "sylvio.dante")
      assert_response :success
      assert_select "tbody tr:first-child td", text: "Sylvio Dante"
      assert_select "tbody tr", count: 1
    end

    test "index should be keyword searchable by phone" do
      get index_url(q: "65432")
      assert_response :success
      assert_select "tbody tr:first-child td", text: "Sylvio Dante"
      assert_select "tbody tr", count: 1
    end

    test "index should be sortable by name" do
      get index_url(sort: "name", sort_direction: "asc")
      assert_response :success
      assert_select "tbody tr:first-child td", text: "Paulie Gaultieri"
      assert_select "tbody tr:nth-child(2) td", text: "Sylvio Dante"

      get index_url(sort: "name", sort_direction: "desc")
      assert_response :success
      assert_select "tbody tr:first-child td", text: "Sylvio Dante"
      assert_select "tbody tr:nth-child(2) td", text: "Paulie Gaultieri"
    end

    test "index should be sortable by email" do
      get index_url(sort: "email", sort_direction: "asc")
      assert_response :success
      assert_select "tbody tr:first-child td", text: "Paulie Gaultieri"
      assert_select "tbody tr:nth-child(2) td", text: "Sylvio Dante"

      get index_url(sort: "email", sort_direction: "asc")
      assert_response :success
      assert_select "tbody tr:first-child td", text: "Paulie Gaultieri"
      assert_select "tbody tr:nth-child(2) td", text: "Sylvio Dante"
    end

    test "index should be sortable by phone" do
      get index_url(sort: "phone", sort_direction: "asc")
      assert_response :success
      assert_select "tbody tr:first-child td", text: "Paulie Gaultieri"
      assert_select "tbody tr:nth-child(2) td", text: "Sylvio Dante"

      get index_url(sort: "phone", sort_direction: "asc")
      assert_response :success
      assert_select "tbody tr:first-child td", text: "Paulie Gaultieri"
      assert_select "tbody tr:nth-child(2) td", text: "Sylvio Dante"
    end
  end
end
