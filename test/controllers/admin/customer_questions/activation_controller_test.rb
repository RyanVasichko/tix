require "application_integration_test_case"

class Admin::CustomerQuestions::ActivationControllerTest < ApplicationIntegrationTestCase
  setup do
    @additional_artists_question = customer_questions(:food_allergies)
  end

  test "should activate customer question and redirect with a success message" do
    post admin_customer_question_activation_url(customer_question_id: @additional_artists_question.id)
    assert_redirected_to admin_customer_questions_path
    assert_equal "Customer question was successfully activated.", flash[:success]
  end
end
