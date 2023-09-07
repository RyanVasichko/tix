class Admin::SeatingCharts::SeatsController < Admin::AdminController
  def new
    render partial: "seat", locals: { seat: SeatingChart::Seat.new }
  end
end
