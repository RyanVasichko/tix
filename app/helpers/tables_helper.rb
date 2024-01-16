module TablesHelper
  def table_header_wrapper_tag(*args, &block)
    merge_class_option(args, "relative overflow-x-auto mt-4 px-4 py-2 bg-gray-100 border-t border-x border-gray-200 rounded-t-xl")
    content = block_given? ? capture(&block) : args.shift
    content_tag(:div, *args) do
      content_tag(:div, content, class: "flex flex-col items-center justify-between space-y-3 md:flex-row")
    end
  end

  def table_tag(*args, &block)
    merge_class_option(args, "w-full text-sm text-left rtl:text-right text-gray-500 border-x border-gray-200")
    content = block_given? ? capture(&block) : args.shift
    content_tag :div, class: "relative overflow-x-auto" do
      content_tag(:table, content, *args)
    end
  end

  def thead_tag(*args, &block)
    merge_class_option(args, "text-xs text-gray-700 uppercase bg-gray-100")
    content = block_given? ? capture(&block) : args.shift
    content_tag(:thead, content, *args)
  end

  def th_tag(*args, &block)
    merge_class_option(args, "px-6 py-3")
    content = block_given? ? capture(&block) : args.shift
    content_tag(:th, content, *args)
  end

  def td_tag(*args, &block)
    merge_class_option(args, "px-6 py-4")
    content = block_given? ? capture(&block) : args.shift
    content_tag(:td, content, *args)
  end

  def tr_for_tbody_tag(*args, &block)
    merge_class_option(args, "bg-white border-b last:border-none hover:bg-gray-50")
    content = block_given? ? capture(&block) : args.shift
    content_tag(:tr, content, *args)
  end

  private

  def merge_class_option(args, additional_classes)
    options = args.extract_options!
    existing_classes = options[:class].to_s.split(' ').group_by { |cls| cls.split('-').first }
    additional_classes.split(' ').each do |additional_class|
      key = additional_class.split('-').first
      # Append the additional class only if it does not override an existing class
      unless existing_classes.key?(key)
        options[:class] = [options[:class], additional_class].compact.join(' ')
      end
    end
    args << options
  end
end
