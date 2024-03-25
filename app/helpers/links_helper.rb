module LinksHelper
  def link_to_new_record(name, path, options = {})
    options[:class] = customization_classes_merged_into_default_classes(options[:class] || "", "flex p-1 rounded bg-gray-100 border border-gray-300 hover:bg-amber-600 hover:text-white")
    link_to path, options do
      concat(svg_plus(class: "h-4 w-4"))
      concat(content_tag(:span, name, class: "sr-only")) if name
    end
  end

  def primary_link_to(name = nil, options = nil, html_options = nil, &block)
    default_classes = "hover:underline text-amber-600 hover:text-amber-500"
    link_to_with_custom_classes(name, options, html_options, default_classes, &block)
  end

  def success_link_to(name = nil, options = nil, html_options = nil, &block)
    default_classes = "hover:underline text-green-500 hover:text-green-700"
    link_to_with_custom_classes(name, options, html_options, default_classes, &block)
  end

  def danger_link_to(name = nil, options = nil, html_options = nil, &block)
    default_classes = "hover:underline text-red-500 hover:text-red-700"
    link_to_with_custom_classes(name, options, html_options, default_classes, &block)
  end

  private

  def link_to_with_custom_classes(name = nil, options = nil, html_options = nil, default_classes = "", &block)
    html_options = options || {} if block_given?
    html_options[:class] ||= ""
    html_options[:class] = customization_classes_merged_into_default_classes(html_options[:class] || "", default_classes)

    if block_given?
      link_to(name, html_options, &block)
    else
      link_to(name, options, html_options)
    end
  end
end
