class Admin::ArtistsController < Admin::AdminController
  include SearchParams

  before_action :set_artist, only: %i[edit update destroy]

  self.default_sort_field = :name
  sortable_by :name

  def index
    @artists = Artist.search(search_params)
    @artists = @artists.active unless include_deactivated?
    @pagy, @artists = pagy(@artists)
  end

  def new
    @artist = Artist.new
  end

  def edit
  end

  def create
    @artist = Artist.new(artist_params)

    if @artist.save
      redirect_to admin_artists_path, flash: { notice: "Artist was successfully created." }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @artist.update(artist_params)
      redirect_to admin_artists_path, flash: { notice: "Artist was successfully updated." }, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @artist.shows.any?
      @artist.update(active: false)
      message = "#{@artist.name} was successfully deactivated."
    else
      @artist.destroy
      message = "#{@artist.name} was successfully deleted."
    end

    redirect_back_or_to admin_artists_path, flash: { notice: message }
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def artist_params
    params.require(:artist).permit(:name, :bio, :url, :image)
  end
end
