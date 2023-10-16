class Admin::CustomerQuestions::ActivationController < Admin::AdminController
  def create
    @customer_question = CustomerQuestion.find(params[:customer_question_id])

    if @customer_question.activate
      redirect_back fallback_location: admin_customer_questions_path, flash: { success: "Customer question was successfully activated." }
    else
      redirect_to admin_customer_questions_path, error: "We encountered an error processing your request. Please try again."
    end
  end
end
