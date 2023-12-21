class MerchController < ApplicationController
  # GET /merch
  def index
    @all_selected = search_params.include?("all") || search_params.empty?
    @selected_category_ids = search_params.reject { |id| id == "all" }
    @merch = Merch.active.includes_image.order(:order)
    @merch = @merch.joins(:categories).where(categories: { id: search_params }) unless @all_selected
    @merch_categories = Merch::Category.joins(:merch).uniq
  end

  def search_params
    params.fetch(:merch_category_id, ["all"]).filter(&:present?)
  end
end
