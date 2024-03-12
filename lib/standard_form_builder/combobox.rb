module StandardFormBuilder
  module Combobox
    def combobox_label(method, text = nil, options = {})
      merge_default_input_classes_into_options_classes(options, "block leading-6 text-gray-900 font-medium")
      label(method, text, options.merge(for: combobox_text_field_id(method)))
    end

    def collection_combobox(property, collection, value_method, text_method, options = {})
      choices = collection.pluck(value_method, text_method)
      selected_value = choices.find { |choice| choice[0] == object.send(property) }
      input_value = selected_value ? selected_value[1] : ""

      disabled = options.delete(:disabled) || false
      options[:data] = {
        controller: ("combobox" unless disabled),
        action: "click@document->combobox#hideOptionsOnOutsideClick",
        selected_option_value: input_value
      }.merge(options[:data] || {})


      @template.content_tag(:div, options) do
        combobox = @template.content_tag(:div, class: "relative mt-2") do
          hidden_field = hidden_field(property, data: { combobox_target: "hiddenField", action: "combobox--option:selected@window->combobox#optionSelected" })
          text_field_options = {
            name: nil,
            disabled: disabled,
            data: { combobox_target: "input", action: "combobox#filter focus->combobox#showOptions" },
            class: "mt-2 block w-full rounded-md border-0 px-2 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-600 sm:leading-6",
            role: "combobox",
            "aria-expanded": false,
            autocomplete: "off"
          }
          add_error_fields_to_options(text_field_options, property)
          text_field = @template.text_field_tag(combobox_text_field_id(property), input_value, text_field_options)

          button = ""
          unless options[:disabled]
            button = @template.content_tag(:button, type: "button", data: { action: "combobox#toggleOptions combobox#focusInput" }, class: "absolute inset-y-0 right-0 flex items-center rounded-r-md px-2 focus:outline-none") do
              @template.content_tag(:svg, class: "h-5 w-5 text-gray-400", viewBox: "0 0 20 20", fill: "currentColor", "aria-hidden": "true") do
                @template.tag(:path, "fill-rule": "evenodd", d: "M10 3a.75.75 0 01.55.24l3.25 3.5a.75.75 0 11-1.1 1.02L10 4.852 7.3 7.76a.75.75 0 01-1.1-1.02l3.25-3.5A.75.75 0 0110 3zm-3.76 9.2a.75.75 0 011.06.04l2.7 2.908 2.7-2.908a.75.75 0 111.1 1.02l-3.25 3.5a.75.75 0 01-1.1 0l-3.25-3.5a.75.75 0 01.04-1.06z", "clip-rule": "evenodd")
              end
            end
          end

          options_list = @template.content_tag(:ul, data: { combobox_target: "optionsList" }, class: "absolute z-10 mt-1 hidden max-h-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm", id: "options", role: "listbox") do
            choices_list = choices.map do |choice|
              @template.content_tag(:li, data: { action: "click->combobox#optionSelected", combobox_target: "option", combobox_option_value_param: choice[0], combobox_option_label_param: choice[1] }, class: "relative cursor-default select-none py-2 pr-4 pl-8 text-gray-900 group hover:bg-blue-600 hover:text-white", role: "option", tabindex: "-1") do
                option_label = @template.content_tag(:span, choice[1], data: { combobox_target: "optionLabel", option_value: choice[0] }, class: "block truncate")
                option_check = @template.content_tag(:span, data: { combobox_target: "optionCheck", option_value: choice[0] }, class: "absolute inset-y-0 left-0 flex #{'hidden' if object.send(property) != choice[0]} items-center text-blue-600 pl-1.5 group-hover:text-white") do
                  @template.content_tag(:svg, class: "h-5 w-5", viewBox: "0 0 20 20", fill: "currentColor", "aria-hidden": "true") do
                    @template.tag(:path, "fill-rule": "evenodd", d: "M16.704 4.153a.75.75 0 01.143 1.052l-8 10.5a.75.75 0 01-1.127.075l-4.5-4.5a.75.75 0 011.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 011.05-.143z", "clip-rule": "evenodd")
                  end
                end
                @template.safe_join([option_label, option_check])
              end
            end

            @template.safe_join(choices_list)
          end

          @template.safe_join([hidden_field, text_field, button, options_list])
        end

        @template.safe_join([combobox, error_message_for(property)])
      end
    end

    private

    def combobox_text_field_id(method)
      method_name = method.to_s
      object_name = object_name().to_s
      "#{object_name}_#{method_name}_combobox]".gsub(/\[|\]|\]\[/, "_")
    end
  end
end
