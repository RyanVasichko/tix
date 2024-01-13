module SvgHelper
  def svg_check
    tag.svg xmlns: "http://www.w3.org/2000/svg", fill: "none", viewbox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor", class: "w-6 h-6" do
      tag.path stroke_linecap: "round", stroke_linejoin: "round", d: "M4.5 12.75l6 6 9-13.5"
    end
  end

  def svg_trash_can_2(options = {})
    svg_options = { xmlns: "http://www.w3.org/2000/svg", fill: "none", viewbox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor", class: "w-6 h-6" }
    svg_options.merge!(options)
    tag.svg **svg_options do
      tag.path stroke_linecap: "round", stroke_linejoin: "round", d: "M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0"
    end
  end


  def svg_trash_can(options = {})
    svg_options = { class: "h-5 w-5", fill: "currentColor", viewBox: "0 0 20 20", aria_hidden: "true" }
    svg_options.merge!(options)
    tag.svg **svg_options do
      tag.path "fill-rule": "evenodd", d: "M8.75 1A2.75 2.75 0 006 3.75v.443c-.795.077-1.584.176-2.365.298a.75.75 0 10.23 1.482l.149-.022.841 10.518A2.75 2.75 0 007.596 19h4.807a2.75 2.75 0 002.742-2.53l.841-10.52.149.023a.75.75 0 00.23-1.482A41.03 41.03 0 0014 4.193V3.75A2.75 2.75 0 0011.25 1h-2.5zM10 4c.84 0 1.673.025 2.5.075V3.75c0-.69-.56-1.25-1.25-1.25h-2.5c-.69 0-1.25.56-1.25 1.25v.325C8.327 4.025 9.16 4 10 4zM8.58 7.72a.75.75 0 00-1.5.06l.3 7.5a.75.75 0 101.5-.06l-.3-7.5zm4.34.06a.75.75 0 10-1.5-.06l-.3 7.5a.75.75 0 101.5.06l.3-7.5z", "clip-rule": "evenodd"
    end
  end

  def svg_plus_icon
    content_tag :svg, class: "h-3.5 w-3.5 mr-2", fill: "currentColor", viewbox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg", aria_hidden: "true" do
      content_tag :path, nil, clip_rule: "evenodd", fill_rule: "evenodd", d: "M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z"
    end
  end
end
