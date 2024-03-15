module SearchParams
  extend ActiveSupport::Concern

  included do
    class_attribute :sortable_fields, default: []
    class_attribute :default_sort_field, default: nil

    before_action :set_default_sort_field, only: :index
    before_action :set_default_sort_direction, only: :index

    helper_method :sort, :sort_direction, :search_params
  end

  module ClassMethods
    def sortable_by(*fields)
      self.sortable_fields = fields.map(&:to_s)
    end
  end

  def search_params
    {
      q: search_keyword,
      sort: sort,
      sort_direction: sort_direction
    }
  end

  def include_deactivated?
    params[:include_deactivated] == "1"
  end

  def search_keyword
    params[:q]
  end

  def sort
    if sortable_fields.include?(params[:sort]&.downcase)
      params[:sort].downcase
    else
      default_sort_field
    end
  end

  def sort_direction
    params[:sort_direction].presence_in(%w[asc desc]) || :asc
  end

  private

  def set_default_sort_field
    params[:sort] = default_sort_field if params[:sort].blank?
  end

  def set_default_sort_direction
    params[:sort_direction] = "asc" if params[:sort_direction].blank?
  end
end
