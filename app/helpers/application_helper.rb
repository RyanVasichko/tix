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
end
