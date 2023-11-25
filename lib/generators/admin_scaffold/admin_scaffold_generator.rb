require 'rails/generators'
require 'rails/generators/rails/scaffold/scaffold_generator'
require 'rails/generators/rails/scaffold_controller/scaffold_controller_generator'
require 'rails/generators/erb/scaffold/scaffold_generator'
require 'rails/generators/test_unit/scaffold/scaffold_generator'

module Generators
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

      def create_test_files
        template "functional_test.rb", File.join("test/controllers/admin", controller_class_path, "#{controller_file_name}_controller_test.rb")
        template "system_test.rb", File.join("test/system/admin", class_path, "#{file_name.pluralize}_test.rb")
      end

      def source_paths
        [
          File.expand_path('templates', __dir__),
          File.expand_path('templates/erb', __dir__),
          Erb::Generators::ScaffoldGenerator.source_root,
          Rails::Generators::ScaffoldControllerGenerator.source_root,
          TestUnit::Generators::ScaffoldGenerator.source_root
        ]
      end

      def fixture_name
        @fixture_name ||=
          if mountable_engine?
            (namespace_dirs + [table_name]).join("_")
          else
            table_name
          end
      end

      protected

      def attributes_string
        attributes_hash.map { |k, v| "#{k}: #{v}" }.join(", ")
      end

      def attributes_hash
        return {} if attributes_names.empty?

        attributes_names.filter_map do |name|
          if %w(password password_confirmation).include?(name) && attributes.any?(&:password_digest?)
            ["#{name}", '"secret"']
          elsif !virtual?(name)
            ["#{name}", "@#{singular_table_name}.#{name}"]
          end
        end.sort.to_h
      end

      def virtual?(name)
        attribute = attributes.find { |attr| attr.name == name }
        attribute&.virtual?
      end

      def boolean?(name)
        attribute = attributes.find { |attr| attr.name == name }
        attribute&.type == :boolean
      end

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
end