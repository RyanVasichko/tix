module NavbarHelper
  def navbar_link_to(name, path, controller, options={})
    default_classes = "rounded-md px-3 py-2 text-sm font-medium"
    provided_classes = options.delete(:class) || ""

    active_classes = params[:controller] == controller_name ? "bg-gray-900 text-white" : "text-gray-300 hover:bg-gray-700 hover:text-white"

    combined_classes = "#{default_classes} #{active_classes} #{provided_classes}"

    link_to(name, path, options.merge(class: combined_classes.strip))
  end

  def mobile_navbar_link_to(name, path, controller, options={})
    default_classes = "block rounded-md px-3 py-2 text-base font-medium"
    provided_classes = options.delete(:class) || ""

    active_classes = params[:controller] == controller_name ? "bg-gray-900 text-white" : "text-gray-300 hover:bg-gray-700 hover:text-white"

    combined_classes = "#{default_classes} #{active_classes} #{provided_classes}"

    link_to(name, path, options.merge(class: combined_classes.strip))
  end
end