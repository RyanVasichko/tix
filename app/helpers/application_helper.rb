module ApplicationHelper
  include Pagy::Frontend

  def color_for_flash_message_type(message_type)
    case message_type.to_sym
    when :success
      "green"
    when :error
      "red"
    when :alert
      "yellow"
    when :notice
      "indigo"
    else
      message_type.to_s
    end
  end

  def skip_turbo_caching?
    screens_to_skip = [
      { controller_name: "orders", action_name: "new" }
    ]
    screens_to_skip.include?({ controller_name: controller_name, action_name: action_name })
  end

  def non_blank_errors_for(model)
    model.errors.details.map do |field, errors_array|
      field if errors_array.none? { |error_info| error_info[:error] == :blank }
    end.compact.map { |field| model.errors.full_messages_for(field) }.flatten
  end

  def short_date(date)
    date.strftime("%-m/%-d/%Y")
  end

  def active_tab_from_params
    params[:activeTab]
  end

  def svg_check
    tag.svg xmlns: "http://www.w3.org/2000/svg", fill: "none", viewbox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor", class: "w-6 h-6" do
      tag.path stroke_linecap: "round", stroke_linejoin: "round", d: "M4.5 12.75l6 6 9-13.5"
    end
  end
end
