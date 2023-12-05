class Admin::Shows::ArtistsController < Admin::AdminController
  def new
    @artist = Artist.new

    respond_to :turbo_stream
  end

  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      flash.now[:success] = "Artist was successfully created."
    else
      render :create, status: :unprocessable_entity
    end

    respond_to :turbo_stream
  end

  private

  def artist_params
    params.require(:artist).permit(:name, :bio, :url, :image)
  end
end
