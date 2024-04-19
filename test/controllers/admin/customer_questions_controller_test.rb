require "test_helper"

class Admin::CustomerQuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in FactoryBot.create(:admin)
  end

  test "should get index" do
    customer_question = FactoryBot.create(:customer_question)
    get admin_customer_questions_url
    assert_response :success

    assert_includes response.body, customer_question.question
  end

  test "index should be keyword searchable by question" do
    FactoryBot.create(:customer_question, question: "What is your favorite Radiohead song?")
    FactoryBot.create(:customer_question, question: "What other artists would you like to see perform here?")
    get admin_customer_questions_url(q: "radio")

    assert_response :success
    assert_includes response.body, "What is your favorite Radiohead song?"
    refute_includes response.body, "What other artists would you like to see perform here?"
  end

  test "should be sortable by question" do
    FactoryBot.create(:customer_question, question: "What is your favorite Radiohead song?")
    FactoryBot.create(:customer_question, question: "What other artists would you like to see perform here?")

    get admin_customer_questions_url(sort: "name", sort_direction: "asc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "What is your favorite Radiohead song?"
    assert_select "tbody tr:nth-child(2) td", text: "What other artists would you like to see perform here?"

    get admin_customer_questions_url(sort: "name", sort_direction: "desc")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "What other artists would you like to see perform here?"
    assert_select "tbody tr:nth-child(2) td", text: "What is your favorite Radiohead song?"
  end

  test "should be sortable by active" do
    FactoryBot.create(:customer_question, question: "What is your favorite Radiohead song?", active: false)
    FactoryBot.create(:customer_question, question: "What other artists would you like to see perform here?")

    get admin_customer_questions_url(sort: "active", sort_direction: "asc", include_deactivated: "1")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "What is your favorite Radiohead song?"
    assert_select "tbody tr:nth-child(2) td", text: "What other artists would you like to see perform here?"

    get admin_customer_questions_url(sort: "active", sort_direction: "desc", include_deactivated: "1")
    assert_response :success
    assert_select "tbody tr:first-child td", text: "What other artists would you like to see perform here?"
    assert_select "tbody tr:nth-child(2) td", text: "What is your favorite Radiohead song?"
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
    customer_question = FactoryBot.create(:customer_question)
    get edit_admin_customer_question_url(customer_question), as: :turbo_stream
    assert_response :success
  end

  test "should update customer_question" do
    customer_question = FactoryBot.create(:customer_question)
    patch admin_customer_question_url(customer_question), params: { customer_question: { question: "What is your favorite Radiohead song?" } }
    assert_redirected_to admin_customer_questions_url

    assert_equal "What is your favorite Radiohead song?", customer_question.reload.question
  end

  test "should deactivate customer_question" do
    customer_question = FactoryBot.create(:customer_question)
    assert_difference("CustomerQuestion.count", 0) do
      delete admin_customer_question_url(customer_question)
    end

    assert_not customer_question.reload.active?

    assert_redirected_to admin_customer_questions_url
  end
end
