require "test_helper"

class Admin::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in FactoryBot.create(:admin)
  end

  test "should get index" do
    FactoryBot.create_list(:customer_order, 2)
    FactoryBot.create_list(:guest_order, 2)

    get admin_orders_url

    assert_response :success
  end

  test "index should be keyword searchable by order number" do
    setup_orders_for_search_and_sort_tests

    get admin_orders_url(q: "abc")
    assert_response :success
    assert_select "tbody tr:first-child td a", text: "ABC123"
    assert_select "tbody tr", count: 1
  end

  test "index should be keyword searchable by order date" do
    setup_orders_for_search_and_sort_tests

    get admin_orders_url(q: (Time.current - 1.week).to_fs(:date))
    assert_response :success
    assert_select "tbody tr:first-child td a", text: "ABC123"
    assert_select "tbody tr", count: 1
  end

  test "index should be keyword searchable by user name" do
    setup_orders_for_search_and_sort_tests

    get admin_orders_url(q: "peter bret")
    assert_response :success
    assert_select "tbody tr:first-child td a", text: "ABC123"
    assert_select "tbody tr", count: 1
  end

  test "index should be keyword searchable by guest orderer name" do
    setup_orders_for_search_and_sort_tests

    get admin_orders_url(q: "rachel jan")
    assert_response :success
    assert_select "tbody tr:first-child td a", text: "DEF123"
    assert_select "tbody tr", count: 1
  end

  test "index should be keyword searchable by user phone" do
    setup_orders_for_search_and_sort_tests

    get admin_orders_url(q: "123456")
    assert_response :success
    assert_select "tbody tr:first-child td a", text: "ABC123"
    assert_select "tbody tr", count: 1
  end

  test "index should be keyword searchable by guest orderer phone" do
    setup_orders_for_search_and_sort_tests

    get admin_orders_url(q: "65432")
    assert_response :success
    assert_select "tbody tr:first-child td a", text: "DEF123"
    assert_select "tbody tr", count: 1
  end

  test "index should be keyword searchable by user email" do
    setup_orders_for_search_and_sort_tests

    get admin_orders_url(q: "bretter@exam")
    assert_response :success
    assert_select "tbody tr:first-child td a", text: "ABC123"
    assert_select "tbody tr", count: 1
  end

  test "index should be keyword searchable by guest orderer email" do
    setup_orders_for_search_and_sort_tests

    get admin_orders_url(q: "jansen@ex")
    assert_response :success
    assert_select "tbody tr:first-child td a", text: "DEF123"
    assert_select "tbody tr", count: 1
  end

  test "index should be sortable by order number" do
    setup_orders_for_search_and_sort_tests

    get admin_orders_url(sort: "order_number", sort_direction: "asc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "ABC123"
    assert_select "tbody tr:nth-child(2) td", text: "DEF123"

    get admin_orders_url(sort: "order_number", sort_direction: "desc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "DEF123"
    assert_select "tbody tr:nth-child(2) td", text: "ABC123"
  end

  test "index should be sortable by order date" do
    setup_orders_for_search_and_sort_tests

    get admin_orders_url(sort: "created_at", sort_direction: "asc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "DEF123"
    assert_select "tbody tr:nth-child(2) td", text: "ABC123"

    get admin_orders_url(sort: "created_at", sort_direction: "desc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "ABC123"
    assert_select "tbody tr:nth-child(2) td", text: "DEF123"
  end

  test "index should be sortable by orderer name" do
    setup_orders_for_search_and_sort_tests

    get admin_orders_url(sort: "orderer_name", sort_direction: "asc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "ABC123"
    assert_select "tbody tr:nth-child(2) td", text: "DEF123"

    get admin_orders_url(sort: "orderer_name", sort_direction: "desc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "DEF123"
    assert_select "tbody tr:nth-child(2) td", text: "ABC123"
  end

  test "index should be sortable by orderer phone" do
    setup_orders_for_search_and_sort_tests

    get admin_orders_url(sort: "orderer_phone", sort_direction: "asc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "ABC123"
    assert_select "tbody tr:nth-child(2) td", text: "DEF123"

    get admin_orders_url(sort: "orderer_phone", sort_direction: "desc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "DEF123"
    assert_select "tbody tr:nth-child(2) td", text: "ABC123"
  end

  test "index should be sortable by orderer email" do
    setup_orders_for_search_and_sort_tests

    get admin_orders_url(sort: "orderer_email", sort_direction: "asc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "ABC123"
    assert_select "tbody tr:nth-child(2) td", text: "DEF123"

    get admin_orders_url(sort: "orderer_email", sort_direction: "desc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "DEF123"
    assert_select "tbody tr:nth-child(2) td", text: "ABC123"
  end

  test "index should be sortable by tickets count" do
    setup_orders_for_search_and_sort_tests

    get admin_orders_url(sort: "tickets_count", sort_direction: "asc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "ABC123"
    assert_select "tbody tr:nth-child(2) td", text: "DEF123"

    get admin_orders_url(sort: "tickets_count", sort_direction: "desc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "DEF123"
    assert_select "tbody tr:nth-child(2) td", text: "ABC123"
  end

  test "index should be sortable by balance paid" do
    setup_orders_for_search_and_sort_tests

    get admin_orders_url(sort: "balance_paid", sort_direction: "asc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "ABC123"
    assert_select "tbody tr:nth-child(2) td", text: "DEF123"

    get admin_orders_url(sort: "balance_paid", sort_direction: "desc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "DEF123"
    assert_select "tbody tr:nth-child(2) td", text: "ABC123"
  end

  private

  def setup_orders_for_search_and_sort_tests
    FactoryBot.create(:customer_order,
                      order_number: "ABC123",
                      general_admission_tickets_count: 2,
                      reserved_seating_tickets_count: 3,
                      orderer: FactoryBot.build(:customer,
                                                first_name: "Peter",
                                                last_name: "Bretter",
                                                phone: "(123) 456-7890",
                                                email: "Peter.Bretter@example.com"))
              .tap { |order| order.update!(created_at: Time.current - 1.week, balance_paid: 42.69) }

    FactoryBot.create(:guest_order,
                      order_number: "DEF123",
                      general_admission_tickets_count: 3,
                      reserved_seating_tickets_count: 3,
                      orderer: FactoryBot.build(:guest_orderer,
                                                first_name: "Rachel",
                                                last_name: "Jansen",
                                                phone: "987 654-3210",
                                                email: "RachelJansen@example.com"))
              .tap { |order| order.update!(created_at: Time.current - 2.weeks, balance_paid: 69.42) }
  end
end
