require "test_helper"

class Admin::CustomerQuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_question = FactoryBot.create(:customer_question)
  end

  test "should get index" do
    get admin_customer_questions_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_customer_question_url, as: :turbo_stream
    assert_response :success
  end

  test "should create customer_question" do
    assert_difference("CustomerQuestion.count") do
      post admin_customer_questions_url, params: { customer_question: { question: "What is your favorite Radiohead song?" } }
    end

    created_question = CustomerQuestion.last
    assert_equal "What is your favorite Radiohead song?", created_question.question

    assert_redirected_to admin_customer_questions_url
  end

  test "should get edit" do
    get edit_admin_customer_question_url(@customer_question), as: :turbo_stream
    assert_response :success
  end

  test "should update customer_question" do
    patch admin_customer_question_url(@customer_question), params: { customer_question: { question: "What is your favorite Radiohead song?" } }
    assert_redirected_to admin_customer_questions_url

    assert_equal "What is your favorite Radiohead song?", @customer_question.reload.question
  end

  test "should deactivate customer_question" do
    assert_difference("CustomerQuestion.count", 0) do
      delete admin_customer_question_url(@customer_question)
    end

    assert_not @customer_question.reload.active?

    assert_redirected_to admin_customer_questions_url
  end
end
