namespace :storage do
  desc "Clear storage directory"
  task :clear => :environment do
    storage_path = Rails.root.join("storage")
    Dir.foreach(storage_path) do |item|
      next if item == "." or item == ".."
      FileUtils.rm_rf(File.join(storage_path, item))
    end
  end
end

Rake::Task["db:fixtures:load"].enhance(["storage:clear"])
Rake::Task["db:factories:load"].enhance(["storage:clear"])
Rake::Task["db:create"].enhance(["storage:clear"])
