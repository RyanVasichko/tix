class Admin::TicketTypesController < Admin::AdminController
  include SearchParams

  before_action :set_ticket_type, only: %i[ edit update destroy ]

  sortable_by :name, :convenience_fee_type, :payment_method, :active, :venue_name
  self.default_sort_field = :name

  # GET /admin/ticket_types
  def index
    @ticket_types = TicketType.includes(:venue).search(search_params)
    @ticket_types = @ticket_types.active unless include_deactivated?
    @pagy, @ticket_types = pagy(@ticket_types)
  end

  # GET /admin/ticket_types/new
  def new
    @ticket_type = TicketType.new
  end

  # GET /admin/ticket_types/1/edit
  def edit
  end

  # POST /admin/ticket_types
  def create
    @ticket_type = TicketType.new(ticket_type_params)

    if @ticket_type.save
      redirect_to admin_ticket_types_url, notice: "Ticket type was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/ticket_types/1
  def update
    if @ticket_type.update(ticket_type_params)
      redirect_to admin_ticket_types_url, notice: "Ticket type was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/ticket_types/1
  def destroy
    @ticket_type.deactivate!
    redirect_back_or_to admin_ticket_types_url, notice: "Ticket type was successfully deactivated.", status: :see_other
  end

  private

  def set_ticket_type
    @ticket_type = TicketType.find(params[:id])
  end

  def ticket_type_params
    permitted_params = [
      :name,
      :convenience_fee,
      :convenience_fee_type,
      :default_price,
      :venue_commission,
      :dinner_included,
      :active,
      :payment_method
    ]
    permitted_params << :venue_id if action_name == "create"

    params.require(:ticket_type).permit(permitted_params)
  end
end
