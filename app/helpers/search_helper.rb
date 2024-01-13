module SearchHelper
  def keyword_search_field(form)
    content_tag(:div, class: "relative") do
      search_icon = content_tag :div, class: "absolute inset-y-0 start-0 flex items-center pl-3 pointer-events-none" do
        content_tag :svg, class: "w-4 h-4 text-gray-500", "aria-hidden": true, xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 20 20" do
          content_tag :path, "", stroke: "currentColor", "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z"
        end
      end

      text_field = form.text_field :keyword,
                                   value: search_keyword,
                                   placeholder: "Search...",
                                   data: { controller: "debounced-submit", action: "debounced-submit#submit" },
                                   class: "block pt-2 pl-10 text-sm text-gray-900 border border-gray-300 rounded-lg w-48 bg-gray-50 focus:ring-amber-500 focus:border-amber-500"
      concat(search_icon)
      concat(text_field)
    end
  end

  def search_keyword
    params.dig(:search, :keyword)
  end
end
