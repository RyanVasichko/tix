class Admin::CustomerQuestionsController < Admin::AdminController
  include SearchParams

  before_action :set_customer_question, only: %i[ edit update destroy ]

  sortable_by :question, :active
  self.default_sort_field = :question

  def index
    @customer_questions = CustomerQuestion.search(search_params)
    @customer_questions = @customer_questions.active unless include_deactivated?
    @pagy, @customer_questions = pagy(@customer_questions)
  end

  def new
    @customer_question = CustomerQuestion.new
  end

  def edit
  end

  def create
    @customer_question = CustomerQuestion.new(customer_question_params)

    if @customer_question.save
      redirect_to admin_customer_questions_path, flash: { success: "Customer question was successfully created." }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @customer_question.update(customer_question_params)
      redirect_to admin_customer_questions_path, flash: { success: "Customer question was successfully updated." }, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @customer_question.deactivate!
    redirect_back fallback_location: admin_customer_questions_url, flash: { success: "Customer question was successfully deactivated." }, status: :see_other
  end

  private

  def set_customer_question
    @customer_question = CustomerQuestion.find(params[:id])
  end

  def customer_question_params
    params.fetch(:customer_question, {}).permit(:question)
  end
end
