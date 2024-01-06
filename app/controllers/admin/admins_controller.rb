class Admin::AdminsController < Admin::AdminController
  include Searchable

  def index
    @admins = User::Admin.order(:first_name)
    @admins = @admins.keyword_search(search_keyword) if search_keyword.present?
    @pagy, @admins = pagy(@admins)
  end
end
