namespace :storage do
  desc "Clear storage directory"
  task clear: :environment do
    storage_path = Rails.root.join("storage")
    return unless Dir.exist?(storage_path)

    Dir.foreach(storage_path) do |item|
      next if %w[. ..].include?(item)

      FileUtils.rm_rf(File.join(storage_path, item))
    end
  end
end
