class Admin::SeatingChartsController < Admin::AdminController
  include SearchParams

  before_action :set_seating_chart, only: %i[show edit update destroy]
  before_action :set_clone_from, only: %i[new]

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
    if @clone_from
      @seating_chart = SeatingChart.build_copy_from(@clone_from)
    else
      @seating_chart = SeatingChart.new do |seating_chart|
        seating_chart.venue = Venue.active.first
        seating_chart.sections.build
      end
    end

    @ticket_types = @seating_chart.venue.ticket_types
  end

  def create
    @seating_chart = SeatingChart.new(seating_chart_params)

    if @seating_chart.save
      redirect_to admin_seating_charts_url, flash: { notice: "Seating chart was successfully created." }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @seating_chart.update(seating_chart_params)
      redirect_to admin_seating_charts_url, flash: { notice: "Seating chart was successfully updated." }
    else
      render :edit, status: :unprocessable_entity
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
    @seating_chart = SeatingChart.find(params[:id])
  end

  def set_clone_from
    @clone_from = SeatingChart.find(params[:clone_from]) if params[:clone_from].present?
  end

  def seating_chart_params
    params.require(:seating_chart).permit(
      :name,
      :venue_layout,
      :venue_id,
      :venue_layout_signed_id,
      sections_attributes: [:id, :name, :ticket_type_id, :_destroy, { seats_attributes: %i[id seat_number table_number x y _destroy] }]
    )
  end
end
