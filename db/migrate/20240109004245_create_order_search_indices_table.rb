class CreateOrderSearchIndicesTable < ActiveRecord::Migration[7.1]
  def up
    execute <<~SQL
      CREATE VIRTUAL TABLE IF NOT EXISTS order_search_indices USING fts5(
        order_id,
        created_at,
        order_number,
        orderer_name,
        orderer_phone,
        orderer_email,
        order_total,
        artist_name,
        tickets_count,
        tokenize='trigram case_sensitive 0'
      );
    SQL
  end

  def down
    execute <<~SQL
      DROP TABLE IF EXISTS order_search_indices;
    SQL
  end
end
