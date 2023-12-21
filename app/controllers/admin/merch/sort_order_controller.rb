class Admin::Merch::SortOrderController < Admin::AdminController
  def update
    Merch.transaction do
      params[:merch].each do |merch_order_param|
        raise ActiveRecord::Rollback unless Merch.find(merch_order_param[:id]).update(order: merch_order_param[:order])
      end
    end

    flash[:notice] = "Merch order was successfully updated."
    head :no_content
  end
end
