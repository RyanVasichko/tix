class DestroyGuestUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = Users::Guest.find_by(id: user_id)
    user&.destroy
  end
end
