class Admin::SeatingChartsController < Admin::AdminController
  include SearchParams

  before_action :set_seating_chart, only: %i[show edit update destroy]

  sortable_by :name
  self.default_sort_field = :name

  def index
    @seating_charts = SeatingChart.search(search_params)
    @seating_charts = @seating_charts.active unless include_deactivated?
    @pagy, @seating_charts = pagy(@seating_charts)
  end

  def show
  end

  def new
    if params[:clone_from]
      # TODO: Should we be dup'ing the sections and seats as well?
      @seating_chart = SeatingChart.includes(sections: :seats).find(params[:clone_from]).dup
      @seating_chart.venue = Venue.find(@seating_chart.venue_id)
      @dup_venue_layout_from = SeatingChart.find(params[:clone_from])
    else
      @seating_chart = SeatingChart.new
      @seating_chart.sections.build.id = SecureRandom.random_number(1_000_000) + 100_000_000_000
      @seating_chart.venue = Venue.active.first
    end

    @ticket_types = @seating_chart.venue.ticket_types
  end

  def create
    @seating_chart = SeatingChart.new(seating_chart_params)

    if seating_chart_params[:venue_layout].nil? &&
      params.require(:seating_chart).permit(:dup_venue_layout_from)[:dup_venue_layout_from]
      @seating_chart.dup_venue_layout_from(
        params.require(:seating_chart).permit(:dup_venue_layout_from)[:dup_venue_layout_from]
      )
    end

    if @seating_chart.save
      redirect_to admin_seating_charts_url, flash: { success: "Seating chart was successfully created." }
    else
      respond_to do |format|
        format.turbo_stream { render :create, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @seating_chart.update(seating_chart_params)
      redirect_to admin_seating_charts_url, flash: { notice: "Seating chart was successfully updated." }
    else
      render :edit
    end
  end

  def deactivate
    @seating_chart = SeatingChart.find(params[:id])
    @seating_chart.deactivate!
    redirect_to admin_seating_charts_url, flash: { notice: "Seating chart was successfully deactivated." }
  end

  def destroy
    @seating_chart.deactivate!
    redirect_back_or_to admin_seating_charts_url, flash: { notice: "Seating chart was successfully destroyed." }
  end

  private

  def set_seating_chart
    @seating_chart = SeatingChart.includes(sections: [:seats]).find(params[:id])
  end

  def seating_chart_params
    params.require(:seating_chart).permit(
      :name,
      :venue_layout,
      :venue_id,
      sections_attributes: [:id, :name, :ticket_type_id, :_destroy, { seats_attributes: %i[id seat_number table_number x y _destroy] }]
    )
  end
end
