require "test_helper"

class Admin::AdminControllersInheritanceTest < ActiveSupport::TestCase
  Dir[Rails.root.join("app/controllers/admin/**/*_controller.rb")].each do |file|
    require file
    relative_path = file.gsub(Rails.root.join("app/controllers/").to_s, "")
    class_name = relative_path.chomp(".rb").camelize

    next if class_name == "Admin::AdminController" # Skip Admin::AdminController

    test "#{class_name} inherits from AdminController" do
      assert_equal Admin::AdminController, class_name.constantize.superclass
    end
  end
end
