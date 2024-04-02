class Merch::ShoppingCartSelectionsController < ApplicationController
  before_action :set_merch, only: %i[ new create ]

  def new
    @merch_selection = @merch.shopping_cart_selections.build(quantity: 1, selectable: @merch) do |new_selection|
      new_selection.options = { name: @merch.option_label, value: @merch.options.first } if @merch.options.any?
    end
  end

  def create
    @merch_selection = Current.user.shopping_cart.selections.find_or_initialize_by \
      selectable: @merch,
      options: selection_params[:options].to_h
    @merch_selection.quantity = if @merch_selection.new_record?
                                  selection_params[:quantity].to_i
                                else
                                  @merch_selection.quantity + selection_params[:quantity].to_i
                                end

    if @merch_selection.save
      redirect_back_or_to merch_index_url, flash: { notice: "Your shopping was cart was successfully updated." }
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_merch
    @merch = Merch.active.find(params[:merch_id])
  end

  def selection_params
    params.fetch(:shopping_cart_selection, {}).permit(:quantity, options: {})
  end
end
