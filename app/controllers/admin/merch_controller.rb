class Admin::MerchController < Admin::AdminController
  before_action :set_merch, only: %i[show edit update destroy]

  def index
    @include_off_sale = params[:include_off_sale] == "1"
    @merch = Merch.includes(:categories)
    @merch = @merch.order(:order)
    @merch_categories = Merch::Category.all.order(:name)
  end

  def show
  end

  def new
    @merch = Merch.new
  end

  def edit
  end

  def create
    @merch = Merch.new(merch_params)

    if @merch.save
      redirect_to admin_merch_index_url, notice: "Merch was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @merch.update(merch_params)
      redirect_to admin_merch_index_path, notice: "Merch was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @merch.deactivate
    redirect_back_or_to admin_merch_index_url, notice: "Merch was taken off sale."
  end

  private

  def set_merch
    @merch = Merch.find(params[:id])
  end

  def merch_params
    params
      .fetch(:merch, {})
      .permit(:name, :description, :price, :image, { category_ids: [] }, categories_attributes: [:name])
      .tap { |whitelisted| whitelisted[:categories_attributes]&.reject! { |_, v| v[:name].blank? } }
  end
end
