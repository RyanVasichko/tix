return unless Rails.env.production? && ENV.fetch("SECRET_KEY_BASE_DUMMY", "0") != "1"

file_logger = ActiveSupport::Logger.new(Rails.root.join("log", "production.log"), 2, 50.megabytes)
Rails.logger.broadcast_to(file_logger)

error_logger = ActiveSupport::Logger.new(Rails.root.join("log", "production-error.log"), 2, 50.megabytes)
error_logger.level = Logger::ERROR
Rails.logger.broadcast_to(error_logger)
