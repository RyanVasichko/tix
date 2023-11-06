class Admin::Shows::SectionsFieldsController < Admin::AdminController
  def index
    seating_chart_sections = SeatingChart::Section.where(seating_chart_id: params[:seating_chart_id])

    @show_sections = seating_chart_sections.map do |section|
      Show::Section.new(name: section.name, seating_chart_section_id: section.id)
    end
  end
end
