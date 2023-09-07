class Admin::SeatingChartsController < ApplicationController
  before_action :set_seating_chart, only: %i[show edit update destroy]

  def index
    @seating_charts = SeatingChart.active
  end

  def show; end

  def new
    if params[:clone_from]
      @seating_chart = SeatingChart.find(params[:clone_from]).dup
      @dup_venue_layout_from = SeatingChart.find(params[:clone_from])
    else
      @seating_chart = SeatingChart.new
      @seating_chart.sections.build.id = SecureRandom.random_number(1_000_000) + 100_000_000
    end
  end

  def create
    @seating_chart = SeatingChart.new(seating_chart_params)

    unless seating_chart_params[:venue_layout]
      @seating_chart.dup_venue_layout_from(params.require(:seating_chart).permit(:dup_venue_layout_from)[:dup_venue_layout_from])
    end

    if @seating_chart.save
      redirect_to admin_seating_charts_url, notice: 'Seating chart was successfully created.'
    else
      respond_to do |format|
        format.turbo_stream
        format.html { render :new }
      end
    end
  end

  def update
    if @seating_chart.update(seating_chart_params)
      redirect_to admin_seating_charts_url, notice: 'Seating chart was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @seating_chart.destroy
    redirect_to admin_seating_charts_url, notice: 'Seating chart was successfully deleted.'
  end

  private

  def set_seating_chart
    @seating_chart = SeatingChart.includes(sections: [:seats]).find(params[:id])
  end

  def seating_chart_params
    params.require(:seating_chart).permit(:name, :venue_layout,
                                          sections_attributes: [:id, :name, :_destroy, { seats_attributes: %i[id seat_number table_number x y _destroy] }])
  end
end
