module StandardFormBuilder
  module CurrencyField
    def currency_field(method, options = {})
      value_options = options.delete(:value_options) || { precision: 2 }
      merge_default_input_classes_into_options_classes(options, "mt-2 block w-full rounded-md border-0 px-2 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-800 sm:leading-6 pl-7 pr-12 no-spin")
      add_error_fields_to_options(options, method)
      options[:min] ||= "0"
      options[:step] ||= "0.01"

      currency_symbol_span = @template.content_tag(:span, "$", class: "text-gray-500")
      currency_symbol_div = @template.content_tag(:div, currency_symbol_span, class: "pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3")

      number_field = ActionView::Helpers::FormBuilder.instance_method(:number_field).bind(self).call(
        method,
        options.merge(value: @template.number_with_precision(object.send(method), **value_options))
      )

      currency_field_div = @template.content_tag(:div, class: "relative mt-2 rounded-md shadow-sm") do
        @template.safe_join([currency_symbol_div, number_field])
      end

      @template.safe_join([currency_field_div, error_message_for(method)])
    end
  end
end
