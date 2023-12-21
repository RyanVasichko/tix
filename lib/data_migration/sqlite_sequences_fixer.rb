module DataMigration
  class SqliteSequencesFixer
    def fix_sequences
      puts "Fixing sequences..."

      ActiveRecord::Base.connection.tables
                        .reject { |table_name| FORBIDDEN_TABLE_NAMES.include?(table_name) }
                        .each do |table|
        # Skip tables without an 'id' column or where 'id' is not an integer
        next unless ActiveRecord::Base.connection.columns(table).find { |c| c.name == 'id' && c.type == :integer }

        # Find the maximum id value in the table
        result = ActiveRecord::Base.connection.execute("SELECT MAX(id) FROM #{table}").first
        max_id = result&.values&.first

        # Skip if no rows or max_id is nil or zero
        next if max_id.nil? || max_id == 0

        # Update the sqlite_sequence table
        ActiveRecord::Base.connection.execute("UPDATE sqlite_sequence SET seq = #{max_id} WHERE name = '#{table}'")
      end

      puts "Fixed sequences"
    end

    FORBIDDEN_TABLE_NAMES = %w[
      ar_internal_metadata
      schema_migrations
      active_storage_variant_records
      active_storage_blobs
    ].freeze
  end
end
