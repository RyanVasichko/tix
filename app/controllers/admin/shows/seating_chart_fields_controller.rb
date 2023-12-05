class Admin::Shows::SeatingChartFieldsController < Admin::AdminController
  def index
    @venue = Venue.find(params[:venue_id])
    @seating_charts = @venue.seating_charts.active
    @show = Show::ReservedSeatingShow.new(venue: @venue, seating_chart_id: @seating_charts.first.id) do |show|
      @seating_charts.first.sections.each do |section|
        show.sections.build(name: section.name, seating_chart_section_id: section.id)
      end
    end
  end
end
