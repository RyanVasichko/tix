module DoseyDoeTicketsFormBuilder
  module SubmitButton
    def submit(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)
      value ||= submit_default_value

      add_class_to_options(options, "btn-primary group flex items-center justify-center")

      @template.button_tag(type: "submit", **options) do
        @template.safe_join [
                              @template.content_tag(:div, nil, class: "mr-2 group-disabled:block hidden h-4 w-4 loader"),
                              @template.content_tag(:span, value),
                            ]
      end
    end
  end
end
