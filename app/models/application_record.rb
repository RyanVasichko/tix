class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def dump_fixture
    attributes_for_yaml = attributes

    attributes_for_yaml.transform_values! do |value|
      if value.is_a?(BigDecimal)
        value.to_f
      elsif value.is_a?(ActiveSupport::TimeWithZone)
        value.strftime("%Y-%m-%d %H:%M:%S")
      else
        value
      end
    end

    fixture_file = "#{Rails.root}/test/fixtures/#{self.class.table_name}.yml"
    File.open(fixture_file, "a+") do |f|
      f.puts({ "#{self.class.table_name.singularize}_#{id}" => attributes_for_yaml }.to_yaml.sub!(/---\s?/, "\n"))
    end
  end
end
