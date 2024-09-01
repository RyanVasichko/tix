class Admin::ShowsController < Admin::AdminController
  include SearchParams

  before_action :set_admin_show, only: %i[edit update destroy]

  self.default_sort_field = :show_date
  sortable_by :show_date, :artist_name, :venue_name

  def index
    shows = Show.search(search_params)
    shows = shows.upcoming unless params.dig(:search, :show_off_sale) == "1"

    @pagy, @shows = pagy(shows)
  end

  def new
    venue = Venue.joins(:seating_charts).merge(SeatingChart.active).first
    @seating_charts = venue.seating_charts.active
    seating_chart = @seating_charts.first
    @show = Shows::ReservedSeating.new(venue_id: venue.id, seating_chart_id: seating_chart.id) do |show|
      show.seating_chart_id = seating_chart.id
      seating_chart.sections.each do |section|
        show.sections.build(name: section.name, seating_chart_section_id: section.id)
      end
    end
  end

  def edit
    @seating_charts = @show.venue.seating_charts.active
  end

  def create
    @show = show_type.new(show_params)

    if @show.save
      redirect_to admin_shows_url, flash: { success: "Show was successfully created." }
    else
      venue = @show.venue_id.present? ? Venue.find(@show.venue_id) : Venue.first
      @seating_charts = venue.seating_charts.active
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

  def artist_fields
    @artist = Artist.new
  end

  private

  def set_admin_show
    @show = Show.find(params[:id])
  end

  def show_type
    params.dig(:show, :type).presence_in(%w[Shows::ReservedSeating Shows::GeneralAdmission]).constantize
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
      sections_attributes: permitted_sections_attributes,
      upsales_attributes: permitted_upsales_attributes
    ]
    if action_name == "create"
      permitted_params << :seating_chart_id if show_type == Shows::ReservedSeating
      permitted_params << :artist_id
      permitted_params << :venue_id
      permitted_params << :type
    end

    params.require(:show).permit(permitted_params)
  end

  def permitted_upsales_attributes
    %i[name description quantity price].tap { |a| a << :id if action_name == "update" }
  end

  def permitted_sections_attributes
    if action_name == "create"
      %i[name seating_chart_section_id ticket_price].tap do |a|
        a << :ticket_quantity if show_type == Shows::GeneralAdmission
        a << :convenience_fee if show_type == Shows::GeneralAdmission
      end
    elsif action_name == "update"
      %i[id ticket_price]
    end
  end
end
