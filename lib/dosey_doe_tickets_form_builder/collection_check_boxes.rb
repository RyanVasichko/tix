module DoseyDoeTicketsFormBuilder
  module CollectionCheckBoxes
    def collection_check_boxes(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
      return super if block_given?

      super(method, collection, value_method, text_method, options, html_options) do |b|
        @template.content_tag(:div, class: "relative flex items-start") do
          check_box = @template.content_tag(:div, class: "flex h-6 items-center") do
            b.check_box(class: "form-control-check-box")
          end
          label = @template.content_tag(:div, class: "ml-3 text-sm leading-6") do
            b.label(class: "text-gray-900")
          end

          @template.safe_join([check_box, label])
        end
      end
    end
  end
end
