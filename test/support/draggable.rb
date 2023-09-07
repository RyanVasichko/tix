module Draggable
  def drag_to(element, x, y)
    original_x = element[:cx].to_i
    original_y = element[:cy].to_i

    delta_x = x - original_x
    delta_y = y - original_y

    driver = element.session.driver
    builder = driver.browser.action
    builder.drag_and_drop_by(element.native, delta_x, delta_y).perform
  end
end
