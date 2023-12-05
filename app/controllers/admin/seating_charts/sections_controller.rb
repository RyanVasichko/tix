class Admin::SeatingCharts::SectionsController < Admin::AdminController
  def new
    @section = SeatingChart::Section.new
    @section.id = SecureRandom.random_number(1_000_000) + 100_000_000_000
    if params[:venue_id]
      @section.build_seating_chart(venue: Venue.includes(:ticket_types).find(params[:venue_id]))
    end

    respond_to do |format|
      format.turbo_stream
    end
  end
end
