require "test_helper"

class Admin::Shows::GeneralAdmissionShowSectionFieldsControllerTest < ActionDispatch::IntegrationTest
  test "gets new" do
    get new_admin_shows_general_admission_show_section_field_path, as: :turbo_stream
    assert_response :success
  end
end
