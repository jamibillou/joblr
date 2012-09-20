module ApplicationHelper

  def title
    unless title = @title
      namespace = %w(sessions registrations passwords).include?(controller_name) ? "devise.#{controller_name}" : controller_name
      title = t("#{namespace}.#{action_name}.title")
    end
    "Joblr | #{title}"
  end

  def subdomain?
    request.subdomain.present? && request.subdomain != 'www' && !request.host.match(/^staging.joblr.co|joblr.herokuapp.com|joblr-staging.herokuapp.com$/)
  end

  def multi_level_subdomain?
    request.subdomain.present? && request.subdomains.size == 2 && request.host.match(/^[^\.]+\.(staging.joblr.co|joblr.herokuapp.com|joblr-staging.herokuapp.com)$/)
  end

  def signed_up?(user)
    user && !user.profiles.empty? && user.profile.persisted?
  end

  # Errors
  # ------

  def error_messages(object, options = {})
    errors = unduplicated_errors(object, options).map! do |attribute, message|
      "#{object.class.human_attribute_name(attribute).downcase} #{message}"
    end.to_sentence.humanize+'.'
  end

  def unduplicated_errors(object, options = {})
    object.errors.select do |attribute, message|
      options[:only] ? options[:only].include?(attribute) && message == object.errors[attribute].first : message == object.errors[attribute].first
    end
  end
end
