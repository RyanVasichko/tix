module DoseyDoeTicketsFormBuilder
  class FormBuilder < ::ActionView::Helpers::FormBuilder
    include Combobox, CurrencyField, ImageFieldWithPreview, SubmitButton, CollectionCheckBoxes

    def label(method, text = nil, options = {}, &block)
      add_class_to_options(options, "form-label")
      super(method, text, options, &block)
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      add_class_to_options(options, "form-control-check-box")
      add_error_fields_to_options(options, method)
      super(method, options, checked_value, unchecked_value)
    end

    def radio_button(method, text = nil, options = {}, &block)
      add_class_to_options(options, "form-control-radio-button")
      add_error_fields_to_options(options, method)
      super(method, text, options, &block)
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      add_class_to_options(html_options, "form-control-select")
      add_error_fields_to_options(options, method)
      super(method, collection, value_method, text_method, options, html_options)
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      add_class_to_options(html_options, "form-control-select")
      add_error_fields_to_options(options, method)
      super(method, choices, options, html_options, &block)
    end

    FIELD_METHODS = %i[
      date_field
      time_field
      datetime_field
      number_field
      text_area
      text_field
      email_field
      telephone_field
      password_field
    ].freeze

    FIELD_METHODS.each do |method_name|
      define_method(method_name) do |method, options = {}|
        add_class_to_options(options, "form-control-text")
        add_error_fields_to_options(options, method)
        @template.safe_join([super(method, options), error_message_for(method)])
      end
    end

    private

    def error_message_for(attribute)
      return unless @object

      actual_attribute = attribute_to_check_for_errors(attribute)
      return unless actual_attribute && @object.errors.include?(actual_attribute)

      message = if @object.errors.details[actual_attribute].any? { |error| error[:error] == :blank }
                  "Required"
                else
                  @object.errors.full_messages_for(actual_attribute).join(", ")
                end
      @template.content_tag :p, message, class: "ml-2 mt-2 text-red-500 text-xs italic"

    end

    def add_class_to_options(options, base_class)
      return if options[:skip_class]

      options[:class] = (options[:class] || "") + " #{base_class}"
    end

    def add_error_fields_to_options(options, attribute)
      return unless @object

      return unless @object.errors.include?(attribute_to_check_for_errors(attribute))

      options[:class] = "#{options[:class] || ''} errors"
      options[:data] ||= {}
      options[:data][:controller] = (options[:data][:controller] || "").split(" ").tap { |o| o << "clear-errors" }.join(" ")
      options[:data][:action] = (options[:data][:action] || "").split(" ").tap { |o| o << "focus->clear-errors#clearErrors" }.join(" ")
    end

    def attribute_to_check_for_errors(attribute)
      # Try to infer the association name from the foreign key attribute.
      association_name = attribute.to_s.gsub(/_id$/, "").to_sym if attribute.to_s.ends_with?("_id")
      return association_name if association_name && @object.errors.include?(association_name)

      attribute
    end
  end
end
