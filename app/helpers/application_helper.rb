module ApplicationHelper

  def has_subdomain
    request.subdomain.present? && request.subdomain != 'www'
  end

  def signed_up?(user)
    !user.profiles.empty? && user.profile.valid?
  end

  def error_messages(object, options = {})
    errors = unduplicated_errors(object, options).map! do |attribute, message|
      "#{object.class.human_attribute_name(attribute).downcase} #{message}"
    end.to_sentence
    "#{t('flash.error.base')} #{errors}."
  end

  def unduplicated_errors(object, options = {})
    object.errors.select do |attribute, message|
      options[:only] ? options[:only].include?(attribute) && message == object.errors[attribute].first : message == object.errors[attribute].first
    end
  end

  def validation_errors(attribute, value, options = {})
    @errors = []
    options.each do |k,v|
      case k
        when :presence
          @errors.push "#{attribute} #{t('activerecord.errors.messages.blank')}" if value.blank? && v == true
        when :length
          @errors.push "#{attribute} #{t('activerecord.errors.messages.too_short', count: v[:minimum])}" if v[:minimum] && value.length < v[:minimum]
          @errors.push "#{attribute} #{t('activerecord.errors.messages.too_long',  count: v[:maximum])}" if v[:maximum] && value.length > v[:maximum]
      end
    end
    "#{t('flash.error.base')} #{@errors.to_sentence}." unless @errors.empty?
  end
end
