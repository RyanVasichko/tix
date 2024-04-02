module ButtonsHelper
  def danger_button_tag(content_or_options, options = nil, &block)
    button_tag_with_custom_classes(content_or_options, options, "rounded bg-red-600 px-3 py-2 font-semibold text-white shadow-sm hover:bg-red-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-red-700 group flex items-center justify-center", &block)
  end

  def plus_icon_button(**attributes)
    classes = ["btn", "btn-success"]
    if attributes[:class]
      classes.concat(attributes[:class].split)
      attributes.delete(:class)
    end

    content_tag :button, class: classes.join(" "), **attributes do
      content_tag :i, "", class: "bi bi-plus"
    end
  end

  def primary_button_tag(content_or_options, options = nil, &block)
    button_tag_with_custom_classes(content_or_options, options, "rounded bg-amber-600 px-3 py-2 font-semibold text-white shadow-sm hover:bg-amber-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-amber-700 group flex items-center justify-center", &block)
  end

  private

  def button_tag_with_custom_classes(content_or_options, options = nil, default_classes = "", &block)
    if content_or_options.is_a?(Hash)
      options = content_or_options
    else
      options ||= {}
    end

    options[:class] ||= ""
    options[:class] = customization_classes_merged_into_default_classes(options[:class], default_classes)

    if block_given?
      button_tag(options, &block)
    else
      button_tag(content_or_options, options)
    end
  end
end
