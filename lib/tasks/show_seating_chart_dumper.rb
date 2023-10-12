class ShowSeatingChartDumper
  def dump
    # Clear the file first before appending new data
    File.truncate(show_sections_fixture_file, 0)
    File.truncate(show_seats_fixture_file, 0)

    File.open(show_sections_fixture_file, "a+") do |f|
      f.puts "_fixture:"
      f.puts "  model_class: Show::Section"
      f.puts
    end

    File.open(show_seats_fixture_file, "a+") do |f|
      f.puts "_fixture:"
      f.puts "  model_class: Show::Seat"
      f.puts
    end

    shows = Show.includes(:artist, sections: %i[seating_chart_section seats]).all
    shows.each { |show| dump_show_sections(show) }
  end

  private

  def show_sections_fixture_file
    "#{Rails.root}/test/fixtures/show/sections.yml"
  end

  def show_seats_fixture_file
    "#{Rails.root}/test/fixtures/show/seats.yml"
  end

  def fixture_name_for_show_section(show_section)
    "#{show_section.show.artist.name}_#{show_section.seating_chart_section.name}".downcase.gsub(/\s/, "_")
  end

  def dump_show_sections(show)
    show.sections.each do |show_section|
      attributes_for_yaml = get_yaml_attributes_for_show_section(show, show_section)

      File.open(show_sections_fixture_file, "a+") do |f|
        f.puts({ fixture_name_for_show_section(show_section) => attributes_for_yaml }.to_yaml.gsub(/^---\s/, ""))
        f.puts
      end

      show_section.seats.each { |seat| dump_seat(seat) }
    end
  end

  def dump_seat(seat)
    attributes_for_yaml = seat.attributes
    attributes_for_yaml.delete("show_section_id")
    attributes_for_yaml.delete("reserved_by_id")
    attributes_for_yaml.delete("reserved_until")

    attributes_for_yaml["section"] = fixture_name_for_show_section(seat.section)

    transform_attributes_for_yaml(attributes_for_yaml)

    File.open(show_seats_fixture_file, "a+") do |f|
      fixture_name =
        "#{seat.show.artist.name}_#{seat.section.seating_chart_section.name}_#{seat.seat_number}_#{seat.table_number}".downcase.gsub(
          /\s/,
          "_"
        )
      f.puts({ fixture_name => attributes_for_yaml }.to_yaml.gsub(/^---\s/, ""))
      f.puts
    end
  end

  def get_yaml_attributes_for_show_section(show, show_section)
    attributes_for_yaml = show_section.attributes

    attributes_for_yaml.delete("show_id")
    attributes_for_yaml["show"] = show.artist.name.downcase.gsub(/\s/, "_")

    attributes_for_yaml.delete("seating_chart_section_id")
    attributes_for_yaml["seating_chart_section"] = show_section.seating_chart_section.name.downcase.gsub(/\s/, "_")

    transform_attributes_for_yaml(attributes_for_yaml)

    attributes_for_yaml
  end

  def transform_attributes_for_yaml(attributes_for_yaml)
    attributes_for_yaml.delete("created_at")
    attributes_for_yaml.delete("updated_at")
    attributes_for_yaml.delete("id")

    attributes_for_yaml.transform_values! do |value|
      if value.is_a?(BigDecimal)
        value.to_f
      elsif value.is_a?(ActiveSupport::TimeWithZone)
        value.strftime("%Y-%m-%d %H:%M:%S")
      else
        value
      end
    end
  end
end
