require "application_integration_test_case"

class ShoppingCart::GeneralAdmissionTicketsControllerTest < ApplicationIntegrationTestCase
  setup do
    @show = FactoryBot.create(:general_admission_show)
  end
  test "gets new" do
    get new_shopping_cart_general_admission_show_ticket_url(@show, format: :turbo_stream)
    assert_response :success
  end

  test "should create shopping cart tickets" do
    customer = FactoryBot.create(:customer)
    log_in_as(customer)

    assert_difference -> { customer.shopping_cart.tickets.count }, 2 do
      post shopping_cart_general_admission_show_tickets_url(@show), params: {
        shopping_cart_tickets: {
          "0" => {
            show_section_id: @show.sections.first.id,
            quantity: 1
          },
          "1" => {
            show_section_id: @show.sections.second.id,
            quantity: 2
          }
        }
      }
    end

    assert_redirected_to shows_url
  end

  test "should destroy tickets when update quantity is zero" do
    customer = FactoryBot.create(:customer)
    log_in_as(customer)
    customer.shopping_cart.tickets.create(show_section: @show.sections.first, quantity: 1)

    assert_difference -> { customer.shopping_cart.tickets.count }, -1 do
      post shopping_cart_general_admission_show_tickets_url(@show), params: {
        shopping_cart_tickets: {
          "0" => {
            show_section_id: @show.sections.first.id,
            quantity: 0
          }
        }
      }
    end

    assert_redirected_to shows_url
  end

  test "should destroy tickets" do
    customer = FactoryBot.create(:customer)
    log_in_as(customer)
    customer.shopping_cart.tickets.create(show_section: @show.sections.first, quantity: 1)

    assert_difference -> { customer.shopping_cart.tickets.count }, -1 do
      delete shopping_cart_general_admission_show_ticket_url(@show, customer.shopping_cart.tickets.first)
    end

    assert_redirected_to shows_url
  end

  test "should update tickets" do
    customer = FactoryBot.create(:customer)
    log_in_as(customer)
    customer.shopping_cart.tickets.create(show_section: @show.sections.first, quantity: 1)

    assert_no_difference -> { customer.shopping_cart.tickets.count } do
      patch shopping_cart_general_admission_show_ticket_url(@show, customer.shopping_cart.tickets.first), params: {
        shopping_cart_ticket: {
          quantity: 2
        }
      }
    end

    assert_equal 2, customer.shopping_cart.tickets.first.reload.quantity

    assert_redirected_to shows_url
  end
end
