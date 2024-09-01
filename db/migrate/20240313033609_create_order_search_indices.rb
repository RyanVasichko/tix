class CreateOrderSearchIndices < ActiveRecord::Migration[7.2]
  def change
    execute <<~SQL
      CREATE VIRTUAL TABLE IF NOT EXISTS order_search_indices USING fts5(
        order_id,
        created_at,
        order_number,
        orderer_name,
        orderer_phone,
        orderer_email,
        balance_paid,
        artist_name,
        tickets_count,
        tokenize='trigram case_sensitive 0'
      );
    SQL
  end
end
