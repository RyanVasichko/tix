module CanBeDeactivated
  extend ActiveSupport::Concern

  included do
    attribute :active, default: true

    scope :active, -> { where(active: true) }

    define_model_callbacks :deactivate
  end

  def activate
    update(active: true)
  end

  def activate!
    update!(active: true)
  end

  def deactivate
    run_callbacks :deactivate do
      update(active: false)
    end
  end

  def deactivate!
    run_callbacks :deactivate do
      update!(active: false)
    end
  end

  def deactivated?
    !active?
  end
end
