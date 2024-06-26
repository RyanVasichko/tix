require "test_helper"

class Admin::CustomerQuestions::ActivationControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in FactoryBot.create(:admin)
    @customer_question = FactoryBot.create(:customer_question, :inactive)
  end

  test "should activate customer question and redirect with a success message" do
    post admin_customer_question_activation_url(customer_question_id: @customer_question.id)
    assert_redirected_to admin_customer_questions_path
    assert_equal "Customer question was successfully activated.", flash[:success]
  end
end
