class Admin::Shows::ReservedSeatingShowSectionsFieldsController < Admin::AdminController
  def index
    seating_chart_sections = SeatingChart::Section.where(seating_chart_id: params[:seating_chart_id])

    @show = Show::ReservedSeatingShow.new

    seating_chart_sections.each do |section|
      @show.sections.build(name: section.name, seating_chart_section_id: section.id)
    end
  end
end
