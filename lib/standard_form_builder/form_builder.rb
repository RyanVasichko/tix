module StandardFormBuilder
  class FormBuilder < ::ActionView::Helpers::FormBuilder
    include ApplicationHelper, Combobox, CurrencyField, ImageFieldWithPreview, SubmitButton, CollectionCheckBoxes

    def label(method, text = nil, options = {}, &block)
      if text.is_a?(Hash)
        options = text
        text = nil
      end

      merge_default_input_classes_into_options_classes(options, "block leading-6 text-gray-900 font-medium")

      if options.delete(:required) && block.nil?
        block = Proc.new do
          @template.concat(text || method.to_s.humanize)
          @template.concat(@template.required_label)
        end
      end

      super(method, text, options, &block)
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      merge_default_input_classes_into_options_classes(options, "h-4 w-4 rounded border-gray-300 text-amber-600 accent-amber-600/50 focus:ring-0 focus:ring-offset-0")
      add_error_fields_to_options(options, method)
      super(method, options, checked_value, unchecked_value)
    end

    def radio_button(method, text = nil, options = {}, &block)
      merge_default_input_classes_into_options_classes(options, "mt-5 mr-4 h-4 w-4 border-gray-300 text-amber-600 accent-amber-500")
      add_error_fields_to_options(options, method)
      super(method, text, options, &block)
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      merge_default_input_classes_into_options_classes(html_options, "mt-2 block w-full rounded-md border-0 pr-10 pl-3 text-gray-900 ring-1 ring-inset ring-gray-300 py-1.5 focus:ring-2 focus:ring-offset focus:ring-amber-500/75 sm:leading-6")
      add_error_fields_to_options(options, method)
      super(method, collection, value_method, text_method, options, html_options)
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      merge_default_input_classes_into_options_classes(html_options, "mt-2 block w-full rounded-md border-0 pr-10 pl-3 text-gray-900 ring-1 ring-inset ring-gray-300 py-1.5 focus:ring-2 focus:ring-offset focus:ring-amber-500/75 sm:leading-6")
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
      define_method(method_name) do |method, value = nil, options = {}|
        if value.is_a?(Hash)
          value, options = options, value
        end
        merge_default_input_classes_into_options_classes(options, "mt-2 block w-full rounded border-0 px-2 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-offset focus:ring-amber-500/75  sm:leading-6")
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

    def merge_default_input_classes_into_options_classes(options, base_class)
      return if options[:skip_class]

      options[:class] = customization_classes_merged_into_default_classes(options[:class] || "", base_class)
    end

    def add_error_fields_to_options(options, attribute)
      return unless @object

      return unless @object.errors.include?(attribute_to_check_for_errors(attribute))

      options[:class] ||= ""
      border_classes = options[:class].scan(/\bborder-\S*/)
      options[:class] = options[:class].gsub(/\bborder-\S*/, "")
      options[:class] = "#{options[:class]} border border-red-500"

      options[:data] ||= {}
      options[:data][:clear_errors_error_class] = "border border-red-500"
      options[:data][:clear_errors_success_class] = border_classes.join(" ")
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
