module ApplicationHelper
  def color_for_flash_message_type(message_type)
    case message_type.to_sym
    when :success
      "green"
    when :error
      "red"
    when :alert
      "yellow"
    when :notice
      "indigo"
    else
      message_type.to_s
    end
  end

  def non_blank_errors_for(model)
    model.errors.details.map do |field, errors_array|
      field if errors_array.none? { |error_info| error_info[:error] == :blank }
    end.compact.map { |field| model.errors.full_messages_for(field) }.flatten
  end

  def short_date(date)
    date.strftime("%-m/%-d/%Y")
  end

  def drag_and_drop_file_field(object_name, method, options = {})
    label_text = options[:label_text] || "Image"

    content_tag(:div) do
      concat label object_name, method, label_text, class: "form-label"
      concat content_tag(:div, class: "mt-2 flex justify-center rounded-lg border border-dashed border-gray-900/25 px-6 py-10") {
        content_tag(:div, class: "text-center") do
          concat tag.svg(data: { src: asset_path("path_to_your_svg.svg") }, class: "mx-auto h-12 w-12 text-gray-300")
          concat content_tag(:div, class: "mt-4 flex text-sm leading-6 text-gray-600") {
                   concat label object_name, method, class: "relative cursor-pointer rounded-md bg-white font-semibold text-indigo-600 focus-within:outline-none focus-within:ring-2 focus-within:ring-indigo-600 focus-within:ring-offset-2 hover:text-indigo-500" do
                     concat "Upload a file"
                     concat file_field object_name, method, class: "sr-only", id: "file-upload-#{method}", name: "file-upload-#{method}"
                   end
                   concat content_tag(:p, "or drag and drop", class: "pl-1")
                 }
        end
      }
    end
  end
end
