class Admin::AdminController < ApplicationController
  layout "admin"

  def index
    render html: nil,  layout: 'admin'
  end
end