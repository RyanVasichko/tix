module CanBeDeactivated
  extend ActiveSupport::Concern

  included do
    attribute :active, default: true

    scope :active, -> { where(active: true) }

    before_save :clean_name, if: -> { persisted? && has_attribute?(:name) && active_changed? && active }
    before_save :add_suffix_to_name, if: -> { persisted? && has_attribute?(:name) && active_changed? && !active && !skip_name_suffix }
  end

  def activate
    update(active: true)
  end

  def activate!
    update!(active: true)
  end

  def deactivate
    update(active: false)
  end

  def deactivate!
    update!(active: false)
  end

  def deactivated?
    !active?
  end

  def skip_name_suffix
    false
  end

  private

  def clean_name
    clean_name = name.sub(/ \(Deactivated(\ \d+)?\)\z/, "").strip
    self.name = clean_name unless self.class.where(name: clean_name).exists?
  end

  def add_suffix_to_name
    base_name = "#{name} (Deactivated"
    similar_name_count = self.class.where("name LIKE ?", "#{base_name}%").count

    # Add a count to the name only if there are other similar names.
    suffix = similar_name_count.positive? ? "#{base_name} #{similar_name_count + 1})" : "#{base_name})"
    self.name = suffix
  end
end
