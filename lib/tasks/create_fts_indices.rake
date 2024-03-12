require_relative "../../db/migrate/20240109004245_create_order_search_indices_table"

namespace :db do
  namespace :fts do
    desc "Create FTS indices"
    task create_indices: :environment do
      CreateOrderSearchIndicesTable.new.up
    end
  end
end

Rake::Task["db:prepare"].enhance(["db:fts:create_indices"])
Rake::Task["db:setup"].enhance(["db:fts:create_indices"])
