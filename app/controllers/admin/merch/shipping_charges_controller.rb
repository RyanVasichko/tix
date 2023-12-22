class Admin::Merch::ShippingChargesController < Admin::AdminController
  before_action :set_merch_shipping_charge, only: %i[edit update destroy]

  # GET /merch/shipping_charges/new
  def new
    @shipping_charge = Merch::ShippingCharge.new
  end

  # GET /merch/shipping_charges/1/edit
  def edit
  end

  # POST /merch/shipping_charges
  def create
    @shipping_charge = Merch::ShippingCharge.new(shipping_charge_params)

    if @shipping_charge.save
      redirect_back_or_to admin_merch_index_url, notice: "Merch shipping charge was successfully created.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /merch/shipping_charges/1
  def update
    if @shipping_charge.update(shipping_charge_params)
      redirect_back_or_to admin_merch_index_url, notice: "Merch shipping charge was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /merch/shipping_charges/1
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
