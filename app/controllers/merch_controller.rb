class MerchController < ApplicationController
  helper_method :all_selected?, :selected_category_ids

  def index
    @merch = Merch.includes_image.active.order(:order)
    @merch = @merch.for_categories(selected_category_ids) unless all_selected?
    @merch_categories = Merch::Category.joins(:merch).uniq
  end

  private

  def all_selected?
    search_params.include?("all") || search_params.empty?
  end

  def selected_category_ids
    search_params.reject { |id| id == "all" }.map(&:to_i)
  end

  def search_params
    params.fetch(:merch_category_id, ["all"]).filter(&:present?)
  end
end
