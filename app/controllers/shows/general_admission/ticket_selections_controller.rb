class Shows::GeneralAdmission::TicketSelectionsController < ApplicationController
  before_action :set_show, only: %i[ new create ]

  def new
    @ticket_selections = @show.sections.map do |section|
      Current.user.shopping_cart.find_or_initialize_ticket_selections_for_show_section(section.id)
    end
  end

  def create
    ApplicationRecord.transaction do
      ticket_selection_params.each do |selection_params|
        Current.user.shopping_cart.adjust_ticket_selections_for! show_section_id: selection_params[:show_section_id],
                                                                 quantity: selection_params[:quantity].to_i
      end
    end

    redirect_back_or_to shows_url, flash: { notice: "Your shopping cart was successfully updated." }
  end

  private

  def set_show
    @show = Shows::GeneralAdmission.find(params[:general_admission_show_id])
  end

  def ticket_selection_params
    params.permit(shopping_cart_ticket_selections: [:show_section_id, :quantity])[:shopping_cart_ticket_selections].values
  end
end
