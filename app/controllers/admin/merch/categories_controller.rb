class Admin::Merch::CategoriesController < Admin::AdminController
  before_action :set_merch_category, only: %i[edit update destroy]

  # GET /admin/merch/categories
  def index
    @pagy, @merch_categories = pagy(Merch::Category.all)
  end

  # GET /admin/merch/categories/new
  def new
    @merch_category = Merch::Category.new
  end

  # GET /admin/merch/categories/1/edit
  def edit
  end

  # POST /admin/merch/categories
  def create
    @merch_category = Merch::Category.new(merch_category_params)

    if @merch_category.save
      redirect_to admin_merch_categories_url, flash: { success: "Category was successfully created." }
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :create, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/merch/categories/1
  def update
    if @merch_category.update(merch_category_params)
      redirect_to admin_merch_categories_url, flash: { success: "Category was successfully updated." }
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :update, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/merch/categories/1
  def destroy
    @merch_category.destroy
    redirect_to admin_merch_categories_url, flash: { success: "Category was successfully destroyed." }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_merch_category
    @merch_category = Merch::Category.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def merch_category_params
    params.fetch(:merch_category, {}).permit(:name)
  end
end