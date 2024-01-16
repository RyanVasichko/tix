module PaginationHelper
  def custom_pagy_nav_wrapper_tag(*args, &block)
    content = block_given? ? capture(&block) : args.shift

    content_tag :nav,
                content,
                class: "flex items-center flex-column flex-wrap md:flex-row justify-between p-4 pt-4 bg-gray-100 border-x border-b border-gray-200 rounded-b-xl",
                aria_label: "Table navigation"
  end

  def custom_pagy_nav(pagy)
    total_count = @pagy.count
    current_page = @pagy.page
    items_per_page = @pagy.items
    start_row = (current_page - 1) * items_per_page + 1
    end_row = start_row + @pagy.items - 1
    end_row = total_count if end_row > total_count

    custom_pagy_nav_wrapper_tag do
      concat(content_tag(:span, class: "text-sm font-normal text-gray-500 mb-4 md:mb-0 block w-full md:inline md:w-auto") do
        concat("Showing")
        concat("&nbsp;".html_safe)
        concat(content_tag(:span, class: "font-semibold text-gray-900") do
          concat("&nbsp;".html_safe)
          concat("#{start_row} - #{end_row}")
          concat("&nbsp;".html_safe)
        end)
        concat("&nbsp;".html_safe)
        concat("of")
        concat("&nbsp;".html_safe)

        concat(content_tag(:span, class: "font-semibold text-gray-900") do
          concat(number_with_delimiter(total_count))
        end)
      end)

      concat(content_tag(:ul, class: "inline-flex -space-x-px rtl:space-x-reverse text-sm h-8") do
        if pagy.prev
          link = pagy_url_for(pagy, pagy.prev)
          concat(render_flowbite_previous_link(link))
        else
          concat(render_flowbite_previous_link("javascript:void(0);", false))
        end

        pagy.series.each do |item|
          if item == :gap
            concat(render_ellipsis)
            next
          end

          link = pagy_url_for(pagy, item)
          if item.to_s == pagy.page.to_s
            concat(render_flowbite_page_link(link, item, true))
          else
            concat(render_flowbite_page_link(link, item))
          end
        end

        if pagy.next
          link = pagy_url_for(pagy, pagy.next)
          concat(render_flowbite_next_link(link))
        else
          concat(render_flowbite_next_link("javascript:void(0);", false))
        end
      end)
    end
  end

  def previous_and_next_buttons_pagy_nav(pagy)
    return nil unless pagy.pages > 1

    content_tag :nav, class: "flex items-center justify-between border-t border-gray-200 px-4 sm:px-0" do
      if pagy.prev
        link = pagy_url_for(pagy, pagy.prev)
        concat(render_tailwind_ui_previous_link(link))
      else
        concat(render_tailwind_ui_previous_link("#", "text-gray-300 cursor-not-allowed"))
      end

      if pagy.next
        link = pagy_url_for(pagy, pagy.next)
        concat(render_tailwind_ui_next_link(link))
      else
        concat(render_tailwind_ui_next_link("#", "text-gray-300 cursor-not-allowed"))
      end
    end
  end

  private

  def render_tailwind_ui_previous_link(link, classes = "text-gray-500 hover:border-gray-300 hover:text-gray-700")
    content_tag(:div, class: "-mt-px w-0 flex-1 flex") do
      link_to link, class: "inline-flex items-center border-t-2 border-transparent pr-4 pt-4 text-sm font-medium #{classes}" do
        svg_tag = content_tag(:svg, class: "mr-3 h-5 w-5 text-gray-400", viewBox: "0 0 20 20", fill: "currentColor", aria_hidden: true) do
          content_tag(:path, "", fill_rule: "evenodd", d: "M18 10a.75.75 0 01-.75.75H4.66l2.1 1.95a.75.75 0 11-1.02 1.1l-3.5-3.25a.75.75 0 010-1.1l3.5-3.25a.75.75 0 111.02 1.1l-2.1 1.95h12.59A.75.75 0 0118 10z", clip_rule: "evenodd")
        end
        previous_tag = content_tag(:span, "Previous")
        safe_join([svg_tag, previous_tag])
      end
    end
  end

  def render_tailwind_ui_next_link(link, classes = "text-gray-500 hover:border-gray-300 hover:text-gray-700")
    content_tag(:div, class: "-mt-px flex w-0 flex-1 justify-end") do
      link_to link, class: "inline-flex items-center border-t-2 border-transparent pl-1 pt-4 text-sm font-medium #{classes}" do
        next_tag = content_tag(:span, "Next")
        svg_tag = content_tag(:svg, class: "ml-3 h-5 w-5 text-gray-400", viewBox: "0 0 20 20", fill: "currentColor", aria_hidden: true) do
          content_tag(:path, "", fill_rule: "evenodd", d: "M2 10a.75.75 0 01.75-.75h12.59l-2.1-1.95a.75.75 0 111.02-1.1l3.5 3.25a.75.75 0 010 1.1l-3.5 3.25a.75.75 0 11-1.02-1.1l2.1-1.95H2.75A.75.75 0 012 10z", clip_rule: "evenodd")
        end
        safe_join([next_tag, svg_tag])
      end
    end
  end

  def render_flowbite_previous_link(link, clickable = true)
    link_to "Previous", link, class: "flex items-center justify-center px-3 h-8 ms-0 leading-tight text-gray-500 bg-white border border-gray-300 rounded-s-lg hover:bg-gray-100 hover:text-gray-700 #{"cursor-not-allowed" unless clickable}"
  end

  def render_flowbite_next_link(link, clickable = true)
    link_to "Next", link, class: "flex items-center justify-center px-3 h-8 leading-tight text-gray-500 bg-white border border-gray-300 rounded-e-lg hover:bg-gray-100 hover:text-gray-700 #{"cursor-not-allowed" unless clickable}"
  end

  def render_flowbite_page_link(link, text, current = false)
    current_classes = "z-10 text-primary-600 bg-primary-50 border-primary-300 hover:bg-primary-100 hover:text-primary-700"
    non_current_classes = "text-gray-500 bg-white border-gray-300 hover:bg-gray-100 hover:text-gray-700"
    general_classes = "flex items-center justify-center px-3 py-2 text-sm leading-tight border"
    classes = "#{general_classes} #{current ? current_classes : non_current_classes}"
    link_to text, link, aria_current: current ? "page" : nil, class: classes
  end

  def render_ellipsis
    content_tag(:span, "...", class: "inline-flex items-center border-t-2 border-transparent px-4 pt-4 text-sm font-medium text-gray-500")
  end
end
