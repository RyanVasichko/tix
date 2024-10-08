require "application_system_test_case"

class Shows::GeneralAdmissionTest < ApplicationSystemTestCase
  setup do
    @show = FactoryBot.create(:general_admission_show)
  end

  test "adding tickets to the shopping cart" do
    visit shows_url
    user = FactoryBot.create(:customer)
    sign_in user

    assert_difference -> { user.shopping_cart.ticket_selections.count }, 2 do
      within "##{dom_id(@show)}" do
        click_on "Order Tickets"
      end
      section_1 = @show.sections.first
      section_2 = @show.sections.second

      select 1, from: section_1.name
      select 2, from: section_2.name

      click_on "Add to shopping cart"
      assert_selector "#shopping_cart_count", text: "3", wait: 10
    end
  end
end
