module SearchParams
  extend ActiveSupport::Concern

  included do
    class_attribute :sortable_fields, default: []
    class_attribute :default_sort_field, default: nil

    helper_method :sort_by, :sort_direction
  end

  module ClassMethods
    def sortable_by(*fields)
      self.sortable_fields = fields.map(&:to_s)
    end
  end

  def search_params
    {
      q: search_keyword,
      sort_by: sort_by,
      sort_direction: sort_direction
    }
  end

  def include_deactivated?
    params[:include_deactivated] == "1"
  end

  def search_keyword
    params[:q]
  end

  def sort_by
    if sortable_fields.include?(params[:sort]&.downcase)
      params[:sort].downcase
    else
      default_sort_field
    end
  end

  def sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction].to_sym : :asc
  end
end
