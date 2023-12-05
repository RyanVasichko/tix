namespace :faker do
  desc "Generate Faker locale with unique x, y positions"
  task generate_locale: :environment do
    require "yaml"
    require "set"

    # Load the YAML content
    data = YAML.load(File.read(Rails.root.join("test/fixtures/show/seats.yml")))

    # Initialize a set to store unique positions
    unique_positions = Set.new

    # Iterate over the data to extract x and y coordinates
    data.each do |key, value|
      next if key == "_fixture" # Skip the _fixture key
      unique_positions.add("#{value['x']},#{value['y']}") # Store as "x,y" string format
    end

    # Create a new YAML content for the Faker locale
    faker_content = {
      "en" => {
        "faker" => {
          faker: {

            "seating_chart" => { # Use seating_chart instead of coordinates for clarity
                                 "seat_positions" => unique_positions.to_a
            }
          }
        }
      }
    }

    # Write the content to the Faker locale file in config/locales
    File.open(Rails.root.join("config", "locales", "faker_locale_en.yml"), "w") do |file|
      file.write(faker_content.to_yaml)
    end

    puts "Faker locale with unique x, y positions has been generated!"
  end
end
