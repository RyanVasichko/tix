module StandardFormBuilder
  module SubmitButton
    def submit(value = nil, options = {}, &block)
      value, options = nil, value if value.is_a?(Hash)
      value ||= submit_default_value

      merge_default_input_classes_into_options_classes(options, "rounded bg-amber-600 px-3 py-2 font-semibold text-white shadow-sm hover:bg-amber-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-amber-700 group flex items-center justify-center")

      if block_given?
        @template.button_tag(type: "submit", **options, &block)
      else
        @template.button_tag(type: "submit", **options) do
          @template.safe_join [
                                @template.svg_spinner(class: "hidden group-disabled:block h-4 w-4"),
                                @template.content_tag(:span, value)
                              ]
        end
      end
    end
  end
end
