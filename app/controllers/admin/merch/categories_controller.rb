class Admin::Merch::CategoriesController < Admin::AdminController
  before_action :set_merch_category, only: %i[show edit update destroy]

  # GET /admin/merch/categories
  def index
    @merch_categories = Merch::Category.all
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
      respond_to do |format|
        format.html { redirect_to admin_merch_categories_url, notice: "Category was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Category was successfully created." }
      end
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
      respond_to do |format|
        format.html { redirect_to admin_merch_categories_url, notice: "Category was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Category was successfully updated." }
      end
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
    respond_to do |format|
      format.html do
        redirect_to(
          admin_merch_categories_url,
          flash: {
            notice: "Category was successfully destroyed."
          },
          status: :see_other
        )
      end
      format.turbo_stream { flash.now[:notice] = "Category was successfully destroyed." }
    end
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
