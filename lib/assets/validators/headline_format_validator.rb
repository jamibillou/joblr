class HeadlineFormatValidator < ActiveModel::EachValidator

  def validate_each(object, attribute, value)
    unless %w(fulltime partime internship freelance).include? value
      object.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.messages.headline_format'))
    end
  end
end