class AttachedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.attached?

    record.errors.add(attribute, :blank, message: options[:message] || "must be attached")
  end
end
