class ShoppingCarts::MerchSelectionsController < ApplicationController
  before_action :set_merch_selection, only: %i[update destroy]

  def update
    if @merch_selection.update(merch_selection_params)
      respond_to do |format|
        notice = "Shopping cart was successfully updated."
        format.html { redirect_back_or_to root_path, flash: { notice: notice }, status: :see_other }
        format.turbo_stream { flash.now[:notice] = notice }
      end
    else
      redirect_back_or_to root_path, flash: { error: "Shopping cart could not be updated." }, status: :unprocessable_entity
    end
  end
  def destroy
    @merch_selection.destroy
    respond_to do |format|
      notice = "Merch was successfully removed from your shopping cart."
      format.html { redirect_back_or_to root_path, flash: { notice: notice }, status: :see_other }
      format.turbo_stream { flash.now[:notice] = notice }
    end
  end

  private

  def set_merch_selection
    @merch_selection = Current.user.shopping_cart_selections.find(params[:id])
  end

  def merch_selection_params
    params.fetch(:shopping_cart_selection, {}).permit(:quantity)
  end
end
