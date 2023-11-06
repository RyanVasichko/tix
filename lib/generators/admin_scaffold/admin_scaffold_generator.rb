require 'rails/generators/rails/scaffold/scaffold_generator'
require 'rails/generators/rails/scaffold_controller/scaffold_controller_generator'
require 'rails/generators/erb/scaffold/scaffold_generator'

module AdminScaffold
  class AdminScaffoldGenerator < Rails::Generators::ScaffoldGenerator
    source_root File.expand_path('templates', __dir__)
    remove_hook_for :scaffold_controller
    remove_class_option :api

    def create_controller_files
      template 'controller.rb.tt', File.join('app/controllers/admin', class_path, "#{controller_file_name}_controller.rb")
    end

    def create_view_files
      available_views.each do |view|
        filename = filename_with_extensions(view)
        template "#{view}.html.erb.tt", File.join('app/views/admin', controller_file_path, filename)
      end
    end

    def source_paths
      [
        File.expand_path('templates', __dir__),
        File.expand_path('templates/erb', __dir__),
        Erb::Generators::ScaffoldGenerator.source_root,
        Rails::Generators::ScaffoldControllerGenerator.source_root
      ].tap { |p| p += super }
    end

    protected

    def filename_with_extensions(name)
      [name, :html, :erb].compact.join(".")
    end

    def available_views
      ['index', 'edit', 'show', 'new', '_form']
    end

    def permitted_params
      attachments, others = attributes_names.partition { |name| attachments?(name) }
      params = others.map { |name| ":#{name}" }
      params += attachments.map { |name| "#{name}: []" }
      params.join(", ")
    end

    def attachments?(name)
      attribute = attributes.find { |attr| attr.name == name }
      attribute&.attachments?
    end
  end
end

