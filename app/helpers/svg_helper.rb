module SvgHelper
  def svg_check
    tag.svg xmlns: "http://www.w3.org/2000/svg", fill: "none", viewbox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor", class: "w-6 h-6" do
      tag.path stroke_linecap: "round", stroke_linejoin: "round", d: "M4.5 12.75l6 6 9-13.5"
    end
  end
end