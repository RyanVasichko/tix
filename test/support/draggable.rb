module Draggable
  def drag_to(element, x, y)
    original_x = element[:cx].to_i
    original_y = element[:cy].to_i

    delta_x = x - original_x
    delta_y = y - original_y

    driver = element.session.driver
    driver.with_playwright_page do |page|
      bounding_box = element.native.bounding_box
      start_x = bounding_box["x"] + bounding_box["width"] / 2
      start_y = bounding_box["y"] + bounding_box["height"] / 2

      page.mouse.move(start_x, start_y)
      page.mouse.down
      page.mouse.move(start_x + delta_x, start_y + delta_y)
      page.mouse.up
    end
  end
end
