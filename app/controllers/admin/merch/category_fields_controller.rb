class Admin::Merch::CategoryFieldsController < Admin::AdminController
  def new
    @category = Merch::Category.new
  end
end