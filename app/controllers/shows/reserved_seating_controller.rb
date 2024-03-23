class Shows::ReservedSeatingController < ApplicationController
  before_action :set_show, only: %i[show]

  def show
  end

  private

  def set_show
    @show = Shows::ReservedSeating.find(params[:show_id])
  end
end
