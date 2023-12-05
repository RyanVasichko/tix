module PaginationHelper
  def custom_pagy_nav(pagy)
    return nil unless pagy.pages > 1

    content_tag :nav, class: "flex items-center justify-between border-t border-gray-200 px-4 sm:px-0" do
      if pagy.prev
        link = pagy_url_for(pagy, pagy.prev)
        concat(render_previous_link(link))
      else
        concat(render_previous_link("#", "text-gray-300 cursor-not-allowed"))
      end

      concat(content_tag(:div, class: "hidden md:-mt-px md:flex") do
        pagy.series.each do |item|
          if item == :gap
            concat(render_ellipsis)
            next
          end

          link = pagy_url_for(pagy, item)
          if item.to_s == pagy.page.to_s
            concat(render_page_link(link, item, true))
          else
            concat(render_page_link(link, item))
          end
        end
      end)

      if pagy.next
        link = pagy_url_for(pagy, pagy.next)
        concat(render_next_link(link))
      else
        concat(render_next_link("#", "text-gray-300 cursor-not-allowed"))
      end
    end
  end

  private

  def render_previous_link(link, classes = "text-gray-500 hover:border-gray-300 hover:text-gray-700")
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

  def render_next_link(link, classes = "text-gray-500 hover:border-gray-300 hover:text-gray-700")
    content_tag(:div, class: "-mt-px flex w-0 flex-1 justify-end") do
      link_to link, class: "inline-flex items-center border-t-2 border-transparent pl-1 pt-4 text-sm font-medium #{classes}" do \
          next_tag = content_tag(:span, "Next")
          svg_tag = content_tag(:svg, class: "ml-3 h-5 w-5 text-gray-400", viewBox: "0 0 20 20", fill: "currentColor", aria_hidden: true) do
            content_tag(:path, "", fill_rule: "evenodd", d: "M2 10a.75.75 0 01.75-.75h12.59l-2.1-1.95a.75.75 0 111.02-1.1l3.5 3.25a.75.75 0 010 1.1l-3.5 3.25a.75.75 0 11-1.02-1.1l2.1-1.95H2.75A.75.75 0 012 10z", clip_rule: "evenodd")
          end
          safe_join([next_tag, svg_tag])
      end
    end
  end

  def render_page_link(link, text, current = false)
    classes = current ? "border-indigo-500 text-indigo-600" : "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700"
    link_to(text, link, aria_current: current ? "page" : nil, class: "inline-flex items-center border-t-2 px-4 pt-4 text-sm font-medium #{classes}")
  end

  def render_ellipsis
    content_tag(:span, "...", class: "inline-flex items-center border-t-2 border-transparent px-4 pt-4 text-sm font-medium text-gray-500")
  end
end
