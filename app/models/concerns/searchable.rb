module Searchable
  extend ActiveSupport::Concern

  included do
    class_attribute :search_definitions
    self.search_definitions = {}
  end

  class_methods do
    def searchable_by(column_names, search_logic = nil, **options)
      column_names = Array(column_names)
      column_names.each do |column_name|
        search_definitions[column_name] = if search_logic.is_a?(Proc)
                                            search_logic
                                          elsif options[:date_range]
                                            ->(dates) { where(column_name => dates[:start]..dates[:end]) }
                                          else
                                            ->(value) { where(column_name => value) }
                                          end
      end
    end

    def search(params = {})
      query = all
      params.each do |key, value|
        query = query.instance_exec(value, &search_definitions[key]) if search_definitions[key]
      end
      query
    end
  end
end
