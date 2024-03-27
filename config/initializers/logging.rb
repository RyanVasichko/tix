return unless Rails.env.production?

file_logger = ActiveSupport::Logger.new(Rails.root.join("log", "production.log"), 2, 50.megabytes)
Rails.logger.broadcast_to(file_logger)

error_logger = ActiveSupport::Logger.new(Rails.root.join("log", "production-error.log"), 2, 50.megabytes)
error_logger.level = Logger::ERROR

appsignal_logger = Appsignal::Logger.new("rails", level: Logger::Severity::ERROR)
Rails.logger.broadcast_to(appsignal_logger)
