class MerchController < ApplicationController
  # GET /merch
  def index
    @all_selected = search_params.include?("all") || search_params.empty?
    @selected_category_ids = search_params.reject { |id| id == "all" }
    @merch =
      if @all_selected
        Merch.active.includes_image
      else
        Merch.active.includes_image.joins(:categories).where(categories: { id: search_params })
      end
    @merch_categories = Merch::Category.joins(:merch).all
  end

  def search_params
    params.fetch(:merch_category_id, ["all"]).filter(&:present?)
  end
end
