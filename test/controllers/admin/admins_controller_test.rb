require "test_helper"
require_relative "users_grid_tests"

class Admin::AdminsControllerTest < ActionDispatch::IntegrationTest
  include Admin::UsersGridTests

  setup do
    sign_in Users::Admin.first || FactoryBot.create(:admin)
  end

  private

  def user_factory_name
    :admin
  end

  def index_url(**params)
    admin_admins_url(params)
  end
end
