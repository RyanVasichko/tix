class Admin::Merch::CategoriesController < Admin::AdminController
  before_action :set_merch_category, only: %i[edit update destroy]

  def index
    @merch_categories = Merch::Category.all
  end

  def new
    @merch_category = Merch::Category.new
  end

  def edit
  end

  def create
    @merch_category = Merch::Category.new(merch_category_params)

    if @merch_category.save
      redirect_back_or_to admin_merch_index_url, flash: { notice: "Merch category was successfully created." }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @merch_category.update(merch_category_params)
      redirect_back_or_to admin_merch_index_url, flash: { notice: "Merch category was successfully updated." }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @merch_category.destroy
    redirect_back_or_to admin_merch_index_url, flash: { notice: "Merch category was successfully destroyed." }
  end

  private

  def set_merch_category
    @merch_category = Merch::Category.find(params[:id])
  end

  def merch_category_params
    params.fetch(:merch_category, {}).permit(:name)
  end
end
