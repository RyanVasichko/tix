class Tickets::GeneralAdmission < Ticket
  def self.find_or_initialize_for_show_section_and_shopping_cart(shopping_cart, show_section_id)
    in_shopping_cart(shopping_cart).find_or_initialize_by(show_section_id: show_section_id)
  end

  def destroyed_with_selection?
    purchase.nil?
  end
end
