class ShoppingCart::TicketSelections::GeneralAdmissionController < ApplicationController
  before_action :set_ticket_selection, only: %i[update destroy]

  def update
    if @ticket_selection.update(ticket_selection_params)
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
    @ticket_selection.destroy
    respond_to do |format|
      notice = "General admission ticket was successfully removed from your shopping cart."

      format.html { redirect_back_or_to root_path, flash: { notice: notice }, status: :see_other }
      format.turbo_stream { flash.now[:notice] = notice }
    end
  end

  private

  def ticket_selection_params
    params.require(:shopping_cart_selection).permit(:quantity)
  end

  def set_ticket_selection
    @ticket_selection = Current.user.shopping_cart_selections.find(params[:id])
  end
end
