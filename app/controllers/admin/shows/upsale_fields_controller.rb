class Admin::Shows::UpsaleFieldsController < Admin::AdminController
  def new
    @upsale = Show::Upsale.new
  end
end