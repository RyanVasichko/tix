class ShoppingCart::Selection::ExpirationJob < ApplicationJob
  queue_as :default

  def perform(selection_id)
    selection = ShoppingCart::Selection.find_by_id(selection_id)
    return unless selection

    if selection.expired?
      selection.destroy!
    else
      self.class.set(wait_until: selection.expires_at).perform_later(selection)
    end
  end
end
