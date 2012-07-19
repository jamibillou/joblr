class LevelFormatValidator < ActiveModel::EachValidator
  
  def validate_each(object, attribute, value)
    unless ['Beginner', 'Intermediate', 'Advanced', 'Expert'].include? value
      object.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.messages.level_format')) 
    end
  end
end