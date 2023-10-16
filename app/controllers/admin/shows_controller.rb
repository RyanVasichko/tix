class Admin::ShowsController < Admin::AdminController
  before_action :set_admin_show, only: %i[edit update destroy]

  def index
    @shows = Show.upcoming.includes(:artist)
  end

  def new
    @show = Show.new do |show|
      seating_chart = SeatingChart.includes(:sections).first
      show.seating_chart = seating_chart
      seating_chart.sections.each do |section|
        show.sections.build(seating_chart_section: section)
      end
    end
  end

  def edit
  end

  def create
    @show = Show.new(show_params)

    # binding.irb

    if @show.save
      redirect_to admin_shows_url, flash: { success: "Show was successfully created." }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @show.update(show_params)
      redirect_to admin_shows_url, flash: { success: "Show was successfully updated." }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @show.destroy
    redirect_to admin_shows_url, notice: "Show was successfully destroyed."
  end

  private

  def set_admin_show
    @show = Show.find(params[:id])
  end

  def show_params
    permitted_params = [
      :show_date,
      :show_starts_at,
      :doors_open_at,
      :dinner_starts_at,
      :dinner_ends_at,
      :front_end_on_sale_at,
      :front_end_off_sale_at,
      :back_end_on_sale_at,
      :back_end_off_sale_at,
      :additional_text,
      customer_question_ids: [],
      sections_attributes: permitted_sections_attributes_for_action,
      upsales_attributes: permitted_upsales_attributes
    ]
    if action_name == "create"
      permitted_params << :seating_chart_id
      permitted_params << :artist_id
    end

    params.require(:show).permit(permitted_params)
  end

  def permitted_upsales_attributes
    %i[name description quantity price].tap { |a| a << :id if action_name == "update" }
  end

  def permitted_sections_attributes_for_action
    if action_name == "create"
      %i[seating_chart_section_id ticket_price]
    elsif action_name == "update"
      %i[id ticket_price]
    end
  end
end
