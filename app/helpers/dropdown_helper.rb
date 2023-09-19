module DropdownHelper
  def dropdown_link_to(name = nil, options = nil, html_options = {}, &block)
    default_html_options = {
      class: "text-gray-700 block px-4 py-2 text-sm hover:bg-gray-100",
      role: "menuitem",
      tabindex: -1
    }

    final_html_options = default_html_options.merge(html_options)

    link_to(name, options, final_html_options, &block)
  end
end