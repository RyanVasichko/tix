class ShoppingCart::GeneralAdmissionTicketsController < ApplicationController
  def new
    @show = Show.find(params[:general_admission_show_id])
    @shopping_cart_tickets = @show.sections.map do |show_section|
      Current.user.shopping_cart.tickets.find_or_initialize_by(show_section: show_section) do |t|
        t.quantity = 0
      end
    end
    respond_to do |format|
      format.turbo_stream
      # TODO: Handle HTML response
    end
  end

  def create
    ApplicationRecord.transaction do
      create_params.each do |ticket_params|
        ticket = Current.user.shopping_cart.tickets.find_or_initialize_by(show_section_id: ticket_params[:show_section_id])

        if ticket_params[:quantity].to_i.zero?
          ticket.destroy!
        else
          ticket.update!(quantity: ticket_params[:quantity])
        end
      end
    end

    respond_to do |format|
      format.html { redirect_back_or_to shows_url, flash: { notice: "Tickets were successfully added to your shopping cart." } }
      format.turbo_stream
    end
  end

  def destroy
    ticket = Current.user.shopping_cart.tickets.find_by!(id: params[:id])
    ticket.destroy!

    respond_to do |format|
      format.html { redirect_back_or_to shows_url, flash: { notice: "Tickets were successfully removed from your shopping cart." } }
      format.turbo_stream
    end
  end

  def update
    ticket = Current.user.shopping_cart.tickets.find_by!(id: params[:id])
    ticket.update(update_params)

    respond_to do |format|
      format.html { redirect_back_or_to shows_url, flash: { notice: "Tickets were successfully updated." } }
      format.turbo_stream
    end
  end

  private

  def create_params
    params.permit(shopping_cart_tickets: %i[show_section_id quantity])[:shopping_cart_tickets]&.values || []
  end

  def update_params
    params.fetch(:shopping_cart_ticket, {}).permit(:quantity)
  end
end
