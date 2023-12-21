class Admin::Merch::OnSaleController < Admin::AdminController
  def create
    @merch = Merch.find(params[:merch_id])
    @merch.activate

    redirect_back_or_to admin_merch_index_url, notice: "Merch was put on sale."
  end
end
