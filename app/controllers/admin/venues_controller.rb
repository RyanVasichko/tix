class Admin::VenuesController < Admin::AdminController
  before_action :set_venue, only: %i[ show edit update destroy ]

  # GET /admin/venues
  def index
    @show_inactive = params[:show_inactive] == "1"
    @venues = @show_inactive ? Venue.all : Venue.active
    @pagy, @venues = pagy(@venues.order(active: :desc, created_at: :desc))
  end

  # GET /admin/venues/new
  def new
    @venue = Venue.new
  end

  # GET /admin/venues/1/edit
  def edit
  end

  # POST /admin/venues
  def create
    @venue = Venue.new(venue_params)

    if @venue.save
      redirect_to admin_venues_url, notice: "Venue was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/venues/1
  def update
    if @venue.update(venue_params)
      message = venue_params[:active] == "true" ? "Venue was successfully activated." : "Venue was successfully updated."
      redirect_to admin_venues_url, notice: message, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/venues/1
  def destroy
    @venue.deactivate!
    redirect_back_or_to admin_venues_url, notice: "Venue was successfully deactivated.", status: :see_other
  end

  private

  def set_venue
    @venue = Venue.find(params[:id])
  end

  def venue_params
    params.require(:venue).permit(:name, :active)
  end
end
