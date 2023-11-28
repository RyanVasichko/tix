class ApplicationJob < ActiveJob::Base
  discard_on ActiveJob::DeserializationError
  retry_on StandardError, wait: :polynomially_longer, attempts: 20
end
