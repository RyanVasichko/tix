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
    builder = DataTableBuilder.new(collection, self)
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

  def cell_sort_direction(cell) end

  class DataTableBuilder
    def initialize(collection, template)
      @collection, @template, @block = collection, template
      @header_builder = TableHeaderBuilder.new(@template)
      @row_builder = TableRowBuilder.new
    end

    def column(property = nil, header: nil, as: nil, date: false, sortable: true, &block)
      @header_builder.cell(header || property&.to_s&.humanize, as: as || property, sortable: sortable)
      block ||= ->(record) {
        record.public_send(property).yield_self do |value|
          value = value.to_fs(:date) if date
          value
        end
      }
      @row_builder.cell(&block)
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

    def initialize(template)
      @template = template
      self.cells = []
    end

    def cell(text = nil, as: nil, sortable:, &block)
      self.cells << TableHeaderCell.new(text&.to_s&.humanize, as: as || text, params: @template.params, sortable: sortable, &block)
    end
  end

  class TableHeaderCell
    attr_reader :as, :sortable

    def initialize(text = nil, as: nil, params:, sortable:, &block)
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
    attr_accessor :cells

    def initialize
      self.cells = []
    end

    def cell(&block)
      self.cells << TableRowCell.new(&block)
    end
  end

  class TableRowCell
    def initialize(&block)
      @block = block
    end

    def render(record)
      @block.call(record)
    end
  end
end
