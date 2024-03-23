class Admin::Merch::ShippingRatesController < Admin::AdminController
  before_action :set_merch_shipping_rate, only: %i[edit update destroy]

  def index
    @shipping_rates = Merch::ShippingRate.all.order(weight: :asc)
  end

  def new
    @shipping_rate = Merch::ShippingRate.new
  end

  def edit
  end

  def create
    @shipping_rate = Merch::ShippingRate.new(shipping_rate_params)

    if @shipping_rate.save
      redirect_back_or_to admin_merch_index_url, notice: "Merch shipping rate was successfully created.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @shipping_rate.update(shipping_rate_params)
      redirect_back_or_to admin_merch_index_url, notice: "Merch shipping rate was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shipping_rate.destroy!
    redirect_back_or_to admin_merch_index_url, notice: "Merch shipping rate was successfully destroyed.", status: :see_other
  end

  private

  def set_merch_shipping_rate
    @shipping_rate = Merch::ShippingRate.find(params[:id])
  end

  def shipping_rate_params
    params.require(:merch_shipping_rate).permit(:weight, :price)
  end
end
