require "test_helper"

class Admin::Shows::SectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    skip "for now"
    @admin_shows_section = admin_shows_sections(:one)
  end

  test "should get index" do
    get admin_shows_sections_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_shows_section_url
    assert_response :success
  end

  test "should create admin_shows_section" do
    assert_difference("Admin::Shows::Section.count") do
      post admin_shows_sections_url, params: { admin_shows_section: {  } }
    end

    assert_redirected_to admin_shows_section_url(Admin::Shows::Section.last)
  end

  test "should show admin_shows_section" do
    get admin_shows_section_url(@admin_shows_section)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_shows_section_url(@admin_shows_section)
    assert_response :success
  end

  test "should update admin_shows_section" do
    patch admin_shows_section_url(@admin_shows_section), params: { admin_shows_section: {  } }
    assert_redirected_to admin_shows_section_url(@admin_shows_section)
  end

  test "should destroy admin_shows_section" do
    assert_difference("Admin::Shows::Section.count", -1) do
      delete admin_shows_section_url(@admin_shows_section)
    end

    assert_redirected_to admin_shows_sections_url
  end
end
