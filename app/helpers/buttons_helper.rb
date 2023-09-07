module ButtonsHelper
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
end
