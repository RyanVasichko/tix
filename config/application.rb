require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DoseyDoeTickets
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.active_job.queue_adapter = :sidekiq

    config.action_view.field_error_proc = -> (html_tag, instance) do
      tag_type = html_tag.match(/^<([a-z]+)/)&.[](1)

      # We're specifically checking for input, textarea, and select, and excluding radio input.
      return html_tag unless %w[input textarea select].include?(tag_type)
      return html_tag if html_tag =~ /<input[^>]+type=["']radio["']/

      # Modify the tag to include the border classes
      class_attr_index = html_tag.index('class="')

      if class_attr_index
        html_tag.insert class_attr_index + 7, 'border border-red-400 '
      else
        closing_tag_index = html_tag.index('>')
        html_tag.insert closing_tag_index, ' class="border border-red-400"'
      end

      # Check if the field has a blank value and add the "Required" error message
      field_name = instance.instance_variable_get(:@method_name)
      if instance.object.respond_to?(:errors) && instance.object.errors.added?(field_name, :blank)
        html_tag << '<p class="ml-2 text-red-500 text-xs italic">Required</p>'.html_safe
      end

      html_tag.html_safe
    end



    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
