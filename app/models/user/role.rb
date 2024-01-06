class User::Role < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :users, foreign_key: :user_role_id, class_name: "User::Admin"
  before_destroy :ensure_not_referenced_by_any_admins

  private

  def ensure_not_referenced_by_any_admins
    return if users.empty?

    errors.add(:base, "This role is used by admins: #{users.map(&:full_name).join(', ')}")
    throw :abort
  end
end
