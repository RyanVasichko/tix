class Admin::Shows::GeneralAdmissionShowSectionFieldsController < Admin::AdminController
  def new
    respond_to do |format|
      format.turbo_stream
    end
  end
end
