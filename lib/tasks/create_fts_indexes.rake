namespace :db do
  namespace :fts do
    desc "Create FTS indices"
    task create_indices: :environment do
      ApplicationRecord.connection.execute <<-SQL
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
          tokenize='trigram case_sensitive 0');
      SQL
    end
  end
end

Rake::Task["db:prepare"].enhance(["db:fts:create_indices"])
Rake::Task["db:setup"].enhance(["db:fts:create_indices"])
