class ShoppingCart::MerchController < ApplicationController
  before_action :set_shopping_cart_merch, only: %i[edit update destroy]

  # GET /shopping_cart/merch/new
  def new
    @merch = Merch.active.find(params[:merch_id])
    @shopping_cart_merch =
      Current.user.shopping_cart_merch.build(merch: @merch, quantity: 1, option: @merch.options.first)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # POST /shopping_cart/merch
  def create
    @shopping_cart_merch =
      Current.user.shopping_cart_merch.find_by(
        merch_id: shopping_cart_merch_params[:merch_id],
        option: shopping_cart_merch_params[:option]
      )
    if @shopping_cart_merch
      @shopping_cart_merch.quantity = @shopping_cart_merch.quantity + shopping_cart_merch_params[:quantity].to_i
    else
      @shopping_cart_merch = Current.user.shopping_cart_merch.build(shopping_cart_merch_params)
    end

    @merch = Merch.find(params[:user_shopping_cart_merch][:merch_id])

    respond_to do |format|
      if @shopping_cart_merch.save
        Current.user = User.includes_shopping_cart.find(Current.user.id)
        notice = "#{@merch.name} was added to your shopping cart."
        format.html { redirect_to merch_index_url, notice: notice }
        format.turbo_stream { flash.now[:notice] = notice }
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /shopping_cart/merch/1
  def update
    if @shopping_cart_merch.update(shopping_cart_merch_params)
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: "Shopping cart updated.", status: :see_other }
        format.turbo_stream { flash.now[:notice] = "Shopping cart updated" }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /shopping_cart/merch/1
  def destroy
    @shopping_cart_merch.destroy
    @user_has_shopping_cart_merch_for_merch =
      Current.user.shopping_cart_merch.where(merch: @shopping_cart_merch.merch).exists?

    respond_to do |format|
      notice = "#{@shopping_cart_merch.merch.name} was successfully removed from your shopping cart."
      format.html { redirect_back fallback_location: root_path, notice: notice, status: :see_other }
      format.turbo_stream { flash.now[:notice] = notice }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_shopping_cart_merch
    @shopping_cart_merch = User::ShoppingCartMerch.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def shopping_cart_merch_params
    params.fetch(:user_shopping_cart_merch, {}).permit(:merch_id, :quantity, :option)
  end
end
