class Admin::AdminController < ApplicationController
  before_action :require_admin

  layout "admin"

  private

  def require_admin
    raise ActionController::RoutingError.new('Not Found') unless Current.user.admin?
  end
end
