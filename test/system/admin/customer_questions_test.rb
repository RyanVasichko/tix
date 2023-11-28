require "application_system_test_case"

class Admin::CustomerQuestionsTest < ApplicationSystemTestCase
  setup do
    @customer_question_1 = FactoryBot.create(:customer_question)
    @customer_question_2 = FactoryBot.create(:customer_question, :inactive)
  end

  test "visiting the index" do
    visit admin_customer_questions_url

    assert_text @customer_question_1.question
    refute_text @customer_question_2.question

    check "Show inactive"

    assert_text @customer_question_2.question
  end

  test "should create customer question" do
    assert_difference("CustomerQuestion.count") do
      visit admin_customer_questions_url
      click_on "New customer question"

      fill_in "Question", with: "What is your favorite color?"
      click_on "Create Customer question"

      assert_text "Customer question was successfully created"
      assert_text "What is your favorite color?"
    end

    created_question = CustomerQuestion.last
    assert_equal "What is your favorite color?", created_question.question
  end

  test "should update Customer question" do
    assert_difference("CustomerQuestion.count", 0) do
      visit admin_customer_questions_url
      click_on @customer_question_1.question
      fill_in "Question", with: "What is your favorite color?"
      click_on "Update Customer question"

      assert_text "Customer question was successfully updated"
      assert_text "What is your favorite color?"
      assert_equal "What is your favorite color?", @customer_question_1.reload.question
    end
  end

  test "should deactivate Customer question" do
    visit admin_customer_questions_url
    find("##{dom_id(@customer_question_1, :admin)}_dropdown").click
    click_on "Deactivate"

    assert_text "Customer question was successfully deactivated"

    refute @customer_question_1.reload.active?
  end

  test "should activate Customer question" do
    visit admin_customer_questions_url
    check "Show inactive"
    find("##{dom_id(@customer_question_2, :admin)}_dropdown").click
    click_on "Activate"

    assert_text "Customer question was successfully activated"

    assert @customer_question_2.reload.active?
  end
end