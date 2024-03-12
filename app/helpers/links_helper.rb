module LinksHelper
  def link_to_new_record(name, path, options = {})
    options[:class] = classes_merged_into_default_classes(options[:class] || "", "flex p-1 rounded bg-gray-100 border border-gray-300 hover:bg-blue-800 hover:text-white")
    link_to path, options do
      concat(svg_plus(class: "h-4 w-4"))
      concat(content_tag(:span, name, class: "sr-only")) if name
    end
  end
end
