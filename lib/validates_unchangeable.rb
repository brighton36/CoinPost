class UnchangeableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (
      options[:message] || "cannot be changed once assigned"
    ) if !record.new_record? && record.send( ('%s_changed?' % attribute).to_sym)
  end
end
