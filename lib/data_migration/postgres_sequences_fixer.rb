module DataMigration
  class PostgresSequencesFixer
    def fix_sequences
      ActiveRecord::Base.connection.tables
                        .reject { |table_name| FORBIDDEN_TABLE_NAMES.include?(table_name) }
                        .each { |table_name| fix_sequence_for_table(table_name) }
      puts "Sequences fixed"
    end

    private

    def fix_sequence_for_table(table_name)
      puts "Fixing sequence for #{table_name}..."

      id_column = id_column_for_table(table_name)

      if id_column.nil?
        puts "Table #{table_name} doesn't have an ID column. Skipping..."
        return
      end

      sequence_name = sequence_name_for_table(table_name)

      max_id = max_id_for_table(table_name)

      set_sequence_value_to_max_id(sequence_name, max_id)
    end

    def id_column_for_table(table_name)
      ActiveRecord::Base.connection.columns(table_name).find { |column| column.name == "id" }
    end

    def sequence_name_for_table(table_name)
      ActiveRecord::Base.connection.execute(
        <<~SQL
          SELECT d.objid::regclass AS sequence_name
          FROM pg_depend AS d
          JOIN pg_attribute AS a ON d.refobjid = a.attrelid AND d.refobjsubid = a.attnum
          WHERE d.objid = 'public.#{table_name}_id_seq'::regclass
        SQL
      ).first['sequence_name']
    end

    def max_id_for_table(table_name)
      ActiveRecord::Base.connection.execute("SELECT COALESCE(MAX(id), 1) AS max_id FROM #{table_name}").first['max_id']
    end

    def set_sequence_value_to_max_id(sequence_name, max_id)
      ActiveRecord::Base.connection.execute("SELECT setval('#{sequence_name}', #{max_id})")
    end

    FORBIDDEN_TABLE_NAMES = %w[
      ar_internal_metadata
      schema_migrations
      active_storage_variant_records
      active_storage_blobs
    ].freeze
  end
end
