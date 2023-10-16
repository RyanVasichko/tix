class Admin::Shows::SectionsController < Admin::AdminController
  def new
    seating_chart_sections = SeatingChart::Section.where(seating_chart_id: params[:seating_chart_id])

    @show_sections = seating_chart_sections.map { |section| Show::Section.new(seating_chart_section: section) }
  end
end
