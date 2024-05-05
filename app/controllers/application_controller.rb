class ApplicationController < ActionController::Base
  include Authentication, Pagy::Backend

  default_form_builder StandardFormBuilder::FormBuilder
end
