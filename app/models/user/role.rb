class User::Role < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validate :ensure_at_least_one_role_with_manage_admins_permission, if: -> { manage_admins_changed? && !manage_admins? }

  has_many :users, foreign_key: :user_role_id, class_name: "User::Admin"
  before_destroy :ensure_at_least_one_role_with_manage_admins_permission
  before_destroy :ensure_not_referenced_by_any_admins

  private

  def ensure_at_least_one_role_with_manage_admins_permission
    return if User::Role.where(manage_admins: true).where.not(id: id).exists?

    errors.add(:base, "At least one role must have permission to manage admins")
    self.manage_admins = true
    throw :abort
  end

  def ensure_not_referenced_by_any_admins
    return if users.empty?

    errors.add(:base, "This role is used by admins: #{users.map(&:name).join(', ')}")
    throw :abort
  end
end
