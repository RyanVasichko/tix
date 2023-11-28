class Admin::CustomerQuestionsController < Admin::AdminController
  before_action :set_customer_question, only: %i[ edit update destroy ]

  # GET /admin/customer_questions
  def index
    @show_inactive = params[:show_inactive] == "1"
    @customer_questions = @show_inactive ? CustomerQuestion.all : CustomerQuestion.active
    @pagy, @customer_questions = pagy(@customer_questions.order(active: :desc, created_at: :desc))
  end

  # GET /admin/customer_questions/new
  def new
    @customer_question = CustomerQuestion.new
  end

  # GET /admin/customer_questions/1/edit
  def edit
  end

  # POST /admin/customer_questions
  def create
    @customer_question = CustomerQuestion.new(customer_question_params)

    if @customer_question.save
      redirect_to admin_customer_questions_path, flash: { success: "Customer question was successfully created." }
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :create, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/customer_questions/1
  def update
    if @customer_question.update(customer_question_params)
      redirect_to admin_customer_questions_path, flash: { success: "Customer question was successfully updated." }, status: :see_other
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :update, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/customer_questions/1
  def destroy
    @customer_question.deactivate!
    redirect_back fallback_location: admin_customer_questions_url, flash: { success: "Customer question was successfully deactivated." }, status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_customer_question
    @customer_question = CustomerQuestion.find(params[:id])
  end

  def customer_question_params
    params.fetch(:customer_question, {}).permit(:question)
  end
end