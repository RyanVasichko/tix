module TablesHelper
  def table_header_wrapper_tag(&block)
    content_tag :div, class: "relative overflow-x-auto px-4 py-2 bg-gray-100 border-t border-x border-gray-200 rounded-t-xl" do
      content_tag :div, class: "flex flex-col items-center justify-between space-y-3 md:flex-row", &block
    end
  end

  def table_tag(&block)
    content_tag :table, class: "w-full text-sm text-left rtl:text-right text-gray-500 border-x border-gray-200", &block
  end
end
