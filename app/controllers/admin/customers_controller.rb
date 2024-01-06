class Admin::CustomersController < Admin::AdminController
  include Searchable

  def index
    @customers = User::Customer.order(:first_name)
    @customers = @customers.keyword_search(search_keyword) if search_keyword.present?
    @pagy, @customers = pagy(@customers)
  end
end
