class Admin::Merch::ShippingChargesController < Admin::AdminController
  before_action :set_merch_shipping_charge, only: %i[edit update destroy]

  def index
    @shipping_charges = Merch::ShippingCharge.all.order(weight: :asc)
  end

  def new
    @shipping_charge = Merch::ShippingCharge.new
  end

  def edit
  end

  def create
    @shipping_charge = Merch::ShippingCharge.new(shipping_charge_params)

    if @shipping_charge.save
      redirect_back_or_to admin_merch_index_url, notice: "Merch shipping charge was successfully created.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @shipping_charge.update(shipping_charge_params)
      redirect_back_or_to admin_merch_index_url, notice: "Merch shipping charge was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shipping_charge.destroy!
    redirect_back_or_to admin_merch_index_url, notice: "Merch shipping charge was successfully destroyed.", status: :see_other
  end

  private

  def set_merch_shipping_charge
    @shipping_charge = Merch::ShippingCharge.find(params[:id])
  end

  def shipping_charge_params
    params.require(:merch_shipping_charge).permit(:weight, :price)
  end
end
