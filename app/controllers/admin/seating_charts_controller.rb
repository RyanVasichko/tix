class Admin::SeatingChartsController < ApplicationController
  before_action :set_admin_seating_chart, only: %i[ show edit update destroy ]

  # GET /admin/seating_charts or /admin/seating_charts.json
  def index
    @admin_seating_charts = SeatingChart.all
  end

  # GET /admin/seating_charts/1 or /admin/seating_charts/1.json
  def show
  end

  # GET /admin/seating_charts/new
  def new
    @admin_seating_chart = SeatingChart.new
  end

  # GET /admin/seating_charts/1/edit
  def edit
  end

  # POST /admin/seating_charts or /admin/seating_charts.json
  def create
    @admin_seating_chart = SeatingChart.new(admin_seating_chart_params)

    respond_to do |format|
      if @admin_seating_chart.save
        format.html { redirect_to admin_seating_chart_url(@admin_seating_chart), notice: "Seating chart was successfully created." }
        format.json { render :show, status: :created, location: @admin_seating_chart }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_seating_chart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/seating_charts/1 or /admin/seating_charts/1.json
  def update
    respond_to do |format|
      if @admin_seating_chart.update(admin_seating_chart_params)
        format.html { redirect_to admin_seating_chart_url(@admin_seating_chart), notice: "Seating chart was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_seating_chart }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_seating_chart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/seating_charts/1 or /admin/seating_charts/1.json
  def destroy
    @admin_seating_chart.destroy

    respond_to do |format|
      format.html { redirect_to admin_seating_charts_url, notice: "Seating chart was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_seating_chart
      @admin_seating_chart = SeatingChart.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_seating_chart_params
      params.fetch(:admin_seating_chart, {})
    end
end
