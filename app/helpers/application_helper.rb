module ApplicationHelper
  include Pagy::Frontend

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

  def random_index
    SecureRandom.random_number(1_000_000) + 100_000_000_000
  end

  def active_or_inactive_tab_classes_for_controller(controller_name_for_active_classes)
    if controller_name_for_active_classes == controller_name
      "border-indigo-500 text-indigo-600 hover:border-indigo-500 hover:text-indigo-600"
    else
      "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700"
    end
  end

  def active_or_inactive_icon_classes_for_controller(controller_name_for_active_classes)
    if controller_name_for_active_classes == controller_name
      "text-indigo-500 hover:text-indigo-500"
    else
      "text-gray-400 group-hover:text-gray-500"
    end
  end
end
