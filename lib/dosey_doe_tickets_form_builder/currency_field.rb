module DoseyDoeTicketsFormBuilder
  module CurrencyField
    def currency_field(method, options = {})
      value_options = options.delete(:value_options) || { precision: 2 }
      add_class_to_options(options, "form-control-text pl-7 pr-12 no-spin")
      add_error_fields_to_options(options, method)
      options[:min] ||= "0"
      options[:step] ||= "0.01"

      currency_symbol_span = @template.content_tag(:span, "$", class: "text-gray-500 sm:text-sm")
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
