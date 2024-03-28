class Users::Guest::DestroyInactiveJob < ApplicationJob
  queue_as :default

  DAYS_AFTER_WHICH_GUEST_IS_CONSIDERED_INACTIVE = 1

  def perform
    inactive_guests = Users::Guest.where("last_active_at < ?", DAYS_AFTER_WHICH_GUEST_IS_CONSIDERED_INACTIVE.day.ago)
    inactive_guests.in_batches(of: 100).each(&:destroy_all)
  end
end
