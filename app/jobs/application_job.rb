class ApplicationJob < ActiveJob::Base
  retry_on StandardError, wait: :polynomially_longer, attempts: 20 do |job, exception|
    error_message = "[ERROR] | Job #{job.class.name} | (ID: #{job.job_id}} | #{exception.message}"

    Rails.logger.error(error_message)
    Appsignal::Logger.new("Rails").error(error_message)
  end

  discard_on ActiveJob::DeserializationError
end
