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

  def svg_plus(options = {})
    add_svg_width_class_to_options(options)
    add_svg_height_class_to_options(options)
    content_tag :svg, xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor", **options do
      content_tag :path, nil, stroke_linecap: "round", stroke_linejoin: "round", d: "M12 4.5v15m7.5-7.5h-15"
    end
  end

  def svg_arrow_up(options = {})
    add_svg_width_class_to_options(options)
    add_svg_height_class_to_options(options)
    content_tag :svg, xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor", **options do
      content_tag :path, nil, stroke_linecap: "round", stroke_linejoin: "round", d: "M4.5 10.5 12 3m0 0 7.5 7.5M12 3v18"
    end
  end

  def svg_arrow_up_down(options = {})
    add_svg_width_class_to_options(options)
    add_svg_height_class_to_options(options)
    content_tag :svg, xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor", **options do
      content_tag :path, nil, stroke_linecap: "round", stroke_linejoin: "round", d: "M3 7.5 7.5 3m0 0L12 7.5M7.5 3v13.5m13.5 0L16.5 21m0 0L12 16.5m4.5 4.5V7.5"
    end
  end

  def svg_arrow_down(options = {})
    add_svg_width_class_to_options(options)
    add_svg_height_class_to_options(options)
    content_tag :svg, xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor", **options do
      content_tag :path, nil, stroke_linecap: "round", stroke_linejoin: "round", d: "M19.5 13.5 12 21m0 0-7.5-7.5M12 21V3"
    end
  end

  def svg_spinner(options = {})
    customization_classes_merged_into_default_classes(options[:class] || "", "animate-spin -ml-1 mr-3 h-5 w-5 text-white")
    content_tag :svg, xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 24 24", **options do
      safe_join [
                  content_tag(:circle, nil, class: "opacity-25", cx: "12", cy: "12", r: "10", stroke: "currentColor", stroke_width: "4"),
                  content_tag(:path, nil, class: "opacity-75", fill: "currentColor", d: "M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z")
                ]
    end
  end

  def svg_cog(options = {})
    # add_svg_width_class_to_options(options)
    # add_svg_height_class_to_options(options)
    # <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
    # <path stroke-linecap="round" stroke-linejoin="round" d="M10.343 3.94c.09-.542.56-.94 1.11-.94h1.093c.55 0 1.02.398 1.11.94l.149.894c.07.424.384.764.78.93.398.164.855.142 1.205-.108l.737-.527a1.125 1.125 0 0 1 1.45.12l.773.774c.39.389.44 1.002.12 1.45l-.527.737c-.25.35-.272.806-.107 1.204.165.397.505.71.93.78l.893.15c.543.09.94.559.94 1.109v1.094c0 .55-.397 1.02-.94 1.11l-.894.149c-.424.07-.764.383-.929.78-.165.398-.143.854.107 1.204l.527.738c.32.447.269 1.06-.12 1.45l-.774.773a1.125 1.125 0 0 1-1.449.12l-.738-.527c-.35-.25-.806-.272-1.203-.107-.398.165-.71.505-.781.929l-.149.894c-.09.542-.56.94-1.11.94h-1.094c-.55 0-1.019-.398-1.11-.94l-.148-.894c-.071-.424-.384-.764-.781-.93-.398-.164-.854-.142-1.204.108l-.738.527c-.447.32-1.06.269-1.45-.12l-.773-.774a1.125 1.125 0 0 1-.12-1.45l.527-.737c.25-.35.272-.806.108-1.204-.165-.397-.506-.71-.93-.78l-.894-.15c-.542-.09-.94-.56-.94-1.109v-1.094c0-.55.398-1.02.94-1.11l.894-.149c.424-.07.765-.383.93-.78.165-.398.143-.854-.108-1.204l-.526-.738a1.125 1.125 0 0 1 .12-1.45l.773-.773a1.125 1.125 0 0 1 1.45-.12l.737.527c.35.25.807.272 1.204.107.397-.165.71-.505.78-.929l.15-.894Z" />
    # <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
    # </svg>
  end

  private

  def add_svg_height_class_to_options(options)
    options[:class] ||= ""
    options[:class] << " h-6"
  end

  def add_svg_width_class_to_options(options)
    options[:class] ||= ""
    options[:class] << " w-6"
  end
end
