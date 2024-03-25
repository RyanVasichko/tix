class Admin::SeatingCharts::SectionsController < Admin::AdminController
  def new
    @section = SeatingChart::Section.new
    if params[:venue_id]
      venue = Venue.find(params[:venue_id]) if params[:venue_id]
      @section.build_seating_chart(venue: venue)
    end
  end
end
