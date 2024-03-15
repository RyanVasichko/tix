module DataTableHelper
  def turbo_frame_id_for_collection(collection)
    collection.model.model_name.plural
  end

  def data_table(collection:,
                 pagy: nil,
                 new_record_button: true,
                 new_record_url: nil,
                 namespace: :admin,
                 infer_include_deactivated_search_param: true,
                 include_deactivated_label_text: "Include deactivated?",
                 new_record_modal: false,
                 keyword_search: true,
                 keyword_search_url: nil,
                 row_id_suffix: "",
                 &block)
    builder = DataTableBuilder.new(collection, params)
    yield builder

    render "shared/data_table",
           collection: collection,
           builder: builder,
           pagy: pagy,
           new_record_button: new_record_button,
           new_record_url: new_record_url || (new_record_button && new_polymorphic_path([namespace, collection.model].compact)),
           new_record_modal: new_record_modal,
           keyword_search: keyword_search,
           keyword_search_url: keyword_search_url || polymorphic_path([namespace, collection.model].compact),
           include_deactivated_search_param: infer_include_deactivated_search_param && collection.model.column_names.include?("active"),
           include_deactivated_label_text: include_deactivated_label_text,
           row_id_suffix: row_id_suffix
  end

  def data_table_form_with(collection, keyword_search_url, &block)
    form_with \
      url: keyword_search_url,
      data: { turbo_frame: turbo_frame_id_for_collection(collection) },
      method: :get,
      class: "flex items-center justify-between",
      &block
  end

  def data_table_header_cell_sort_query_params(cell)
    {
      sort: cell.as.downcase,
      sort_direction: cell.sort_direction,
      q: params[:q],
      include_deactivated: params[:include_deactivated]
    }.to_query
  end

  class DataTableBuilder
    def initialize(collection, params)
      @collection, @params = collection, params
      @header_builder = TableHeaderBuilder.new(params)
      @row_builder = TableRowBuilder.new
    end

    def column(property = nil, header: nil, as: nil, date: false, sortable: true, cell_class: "", &block)
      @header_builder.cell(header || property&.to_s&.humanize, as: as || property, sortable: sortable)
      block ||= ->(record) {
        record.public_send(property).yield_self do |value|
          value = value.to_fs(:date) if date
          value
        end
      }
      @row_builder.cell(classes: cell_class, &block)
    end

    def head
      yield @header_builder
      nil
    end

    def rows
      yield @row_builder
    end

    def header_cells
      @header_builder.cells
    end

    def row_cells
      @row_builder.cells
    end
  end

  class TableHeaderBuilder
    attr_accessor :cells

    def initialize(params)
      @params = params
      self.cells = []
    end

    def cell(text = nil, as: nil, sortable:, &block)
      self.cells << TableHeaderCell.new(text&.to_s&.humanize, as: as || text, params: @params, sortable: sortable, &block)
    end
  end

  class TableHeaderCell
    attr_reader :as, :sortable

    def initialize(text = nil, as: nil, params:, sortable: true, &block)
      @text, @as, @params, @sortable, @block = text, as, params, sortable, block
      @as ||= @text
    end

    def text
      @text || @block.call
    end

    def sort_direction
      return "asc" unless @params[:sort].to_s.casecmp?(@as.to_s)

      if (@params[:sort_direction] || "asc") == "asc"
        "desc"
      else
        "asc"
      end
    end
  end

  class TableRowBuilder
    attr_reader :cells

    def initialize()
      @cells = []
    end

    def cell(classes: "", &block)
      @cells << TableRowCell.new(classes: classes, &block)
    end
  end

  class TableRowCell
    attr_reader :classes

    def initialize(classes: "", &block)
      @block, @classes = block, classes
    end

    def render(record)
      @block.call(record)
    end
  end
end
