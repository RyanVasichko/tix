module LinksHelper
  def link_to_new_record(name, path, options = {})
    default_classes = "flex p-1 rounded bg-gray-100 border border-gray-300 hover:bg-amber-600 hover:text-white"
    options[:class] ||= customization_classes_merged_into_default_classes(options[:class] || "", default_classes)

    link_to path, options do
      concat(svg_plus(class: "h-4 w-4"))
      concat(content_tag(:span, name, class: "sr-only")) if name
    end
  end
end
