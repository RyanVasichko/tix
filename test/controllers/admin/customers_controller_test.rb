require "test_helper"
require_relative "./users_grid_tests"

class Admin::CustomersControllerTest < ActionDispatch::IntegrationTest
  include Admin::UsersGridTests

  setup do
    sign_in FactoryBot.create(:admin)
  end

  private

  def user_factory_name
    :customer
  end

  def index_url(**params)
    admin_customers_url(params)
  end
end
