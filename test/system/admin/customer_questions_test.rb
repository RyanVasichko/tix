require "application_system_test_case"

class Admin::CustomerQuestionsTest < ApplicationSystemTestCase
  setup do
    @additional_artists_question = customer_questions(:additional_artists)
    @food_allergies_question = customer_questions(:food_allergies)
  end

  test "visiting the index" do
    visit admin_customer_questions_url

    assert_text @additional_artists_question.question
    refute_text @food_allergies_question.question

    check "Show inactive"

    assert_text @food_allergies_question.question
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
      click_on @additional_artists_question.question
      fill_in "Question", with: "What is your favorite color?"
      click_on "Update Customer question"

      assert_text "Customer question was successfully updated"
      assert_text "What is your favorite color?"
      assert_equal "What is your favorite color?", @additional_artists_question.reload.question
    end
  end

  test "should deactivate Customer question" do
    visit admin_customer_questions_url
    find("##{dom_id(@additional_artists_question, :admin)}_dropdown").click
    click_on "Deactivate"

    assert_text "Customer question was successfully deactivated"

    refute @additional_artists_question.reload.active?
  end

  test "should activate Customer question" do
    visit admin_customer_questions_url
    check "Show inactive"
    find("##{dom_id(@food_allergies_question, :admin)}_dropdown").click
    click_on "Activate"

    assert_text "Customer question was successfully activated"

    assert @food_allergies_question.reload.active?
  end
end
