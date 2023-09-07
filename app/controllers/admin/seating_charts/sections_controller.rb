class Admin::SeatingCharts::SectionsController < ApplicationController
  def new
    @section = SeatingChart::Section.new

    respond_to do |format|
      format.turbo_stream
    end
  end
end
