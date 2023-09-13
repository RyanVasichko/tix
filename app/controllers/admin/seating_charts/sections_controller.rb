class Admin::SeatingCharts::SectionsController < Admin::AdminController
  def new
    @section = SeatingChart::Section.new
    @section.id =  SecureRandom.random_number(1_000_000) + 100_000_000_000

    respond_to do |format|
      format.turbo_stream
    end
  end
end
