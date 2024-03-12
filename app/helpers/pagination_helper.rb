module PaginationHelper
  def previous_and_next_buttons_nav(pagy)
    return nil unless pagy.pages > 1

    content_tag :nav, class: "flex items-center justify-between border-t border-gray-200 px-4 sm:px-0" do
      if pagy.prev
        link = pagy_url_for(pagy, pagy.prev)
        concat(previous_link(link))
      else
        concat(previous_link("#", "text-gray-300 cursor-not-allowed"))
      end

      if pagy.next
        link = pagy_url_for(pagy, pagy.next)
        concat(next_link(link))
      else
        concat(next_link("#", "text-gray-300 cursor-not-allowed"))
      end
    end
  end

  def previous_link(link, classes = "text-gray-500 hover:border-gray-300 hover:text-gray-700")
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

  def next_link(link, classes = "text-gray-500 hover:border-gray-300 hover:text-gray-700")
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
end
