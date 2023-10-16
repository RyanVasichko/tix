module Deactivatable
  extend ActiveSupport::Concern

  included do
    attribute :active, default: true

    scope :active, -> { where(active: true) }
  end

  def activate
    update(activate_params)
  end

  def activate!
    update!(activate_params)
  end

  def deactivate
    update(deactivate_params)
  end

  def deactivate!
    update!(deactivate_params)
  end

  private

  def activate_params
    { active: true }.tap do |params|
      if respond_to?(:name)
        # Strip off the (deactivated) part if present, and strip ending whitespace
        clean_name = name.sub(/ \(Deactivated(\ \d+)?\)\z/, '').strip

        record_with_name_already_exists = self.class.where(name: clean_name).exists?
        params[:name] = record_with_name_already_exists ? name : clean_name
      end
    end
  end


  def deactivate_params
    { active: false }.tap do |params|
      if respond_to?(:name)
        base_name = "#{name} (Deactivated"
        similar_name_count = self.class.where("name LIKE ?", "#{base_name}%").count

        # Add a count to the name only if there are other similar names.
        suffix = similar_name_count.positive? ? "#{base_name} #{similar_name_count + 1})" : "#{base_name})"
        params[:name] = suffix
      end
    end
  end
end