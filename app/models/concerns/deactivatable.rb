module Deactivatable
  extend ActiveSupport::Concern

  included do
    attribute :active, default: true

    scope :active, -> { where(active: true) }
  end

  def activate
    update(active: true)
  end

  def deactivate
    update(active: false)
  end

  def deactivate!
    update!(active: false)
  end
end