require_relative "../../db/migrate/20240313033609_create_order_search_indices"

namespace :db do
  namespace :fts do
    desc "Create FTS indices"
    task create_indices: :environment do
      ActiveRecord::Migration.verbose = false
      CreateOrderSearchIndices.migrate(:up)
    end
  end
end

Rake::Task["db:prepare"].enhance(["db:fts:create_indices"])
Rake::Task["db:setup"].enhance(["db:fts:create_indices"])
