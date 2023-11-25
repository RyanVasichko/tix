class Admin::SeatingCharts::TicketTypeOptionsController < Admin::AdminController
  def show
    @ticket_types = TicketType.where(venue: params[:venue_id])
    render partial: "show"
  end
end
