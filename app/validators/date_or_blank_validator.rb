class DateOrBlankValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
    record.errors[attribute] << "must be a valid datetime or blank" unless value.blank? or ((Date.parse(value) rescue nil))
  end
end
