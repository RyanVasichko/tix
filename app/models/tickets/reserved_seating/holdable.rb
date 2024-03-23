module Tickets::ReservedSeating::Holdable
  extend ActiveSupport::Concern

  included do
    belongs_to :held_by, class_name: "Users::Admin", optional: true
  end

  def held?
    held_by.present?
  end

  def hold_for!(admin)
    transaction do
      update!(held_by: admin) if holdable_by?(admin)
      shopping_cart_selection.destroy!
    end
  end

  def release_hold!(user)
    update!(held_by: nil) if user.admin? && held?
  end

  private

  def holdable_by?(admin)
    admin.admin? && selected_by == admin && !sold? && !held?
  end
end
