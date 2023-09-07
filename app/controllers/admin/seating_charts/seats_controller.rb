class Admin::SeatingCharts::SeatsController < ApplicationController
  def new
    render partial: "seat", locals: { seat: SeatingChart::Seat.new }
  end
end
