module ApplicationHelper
  include Pagy::Frontend

  def card(width: "max-w-5xl")
    content_tag :div, class: "mx-auto #{width} overflow-visible rounded-lg border-b border-slate-300 bg-white px-4 py-5 shadow sm:px-6" do
      yield
    end
  end

  def non_blank_errors_for(model)
    model.errors.details.map do |field, errors_array|
      field if errors_array.none? { |error_info| error_info[:error] == :blank }
    end.compact.map { |field| model.errors.full_messages_for(field) }.flatten
  end

  def random_index
    SecureRandom.random_number(1_000_000) + 100_000_000_000
  end

  def customization_classes_merged_into_default_classes(classes, defaults)
    classes_array = classes.split(" ").reject(&:empty?).uniq
    defaults_array = defaults.split(" ").reject(&:empty?).uniq

    classes_array.each do |input_class|
      if input_class.starts_with?("p-")
        defaults_array.reject! { |c| c.starts_with?("p-") || c.starts_with?("px-") || c.starts_with?("py-") }
        next
      end

      %w[px- py- h- w- mt- mb- ml- mr-].each do |prefix|
        if input_class.starts_with?(prefix)
          defaults_array.reject! { |c| c.starts_with?(prefix) }
        end

        sizes = %w[xs sm base lg xl 2xl 3xl 4xl 5xl 6xl 7xl 8xl 9xl]
        sizes.each do |size|
          defaults_array.reject! { |c| sizes.any? { |s| c == "text-#{s}" } } if input_class == "text-#{size}"
        end
      end
    end

    classes_array.concat(defaults_array).join(" ")
  end

  def active_or_inactive_tab_classes_for_controller(controller_name_for_active_classes)
    if controller_name_for_active_classes == controller_name
      "border-amber-500 text-amber-600 hover:border-amber-500 hover:text-amber-600"
    else
      "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700"
    end
  end

  def active_or_inactive_icon_classes_for_controller(controller_name_for_active_classes)
    if controller_name_for_active_classes == controller_name
      "text-amber-500 hover:text-amber-500"
    else
      "text-gray-400 group-hover:text-gray-500"
    end
  end
end
