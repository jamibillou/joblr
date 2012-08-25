module ApplicationHelper

  def has_subdomain
    request.subdomain.present? && request.subdomain != 'www'
  end

  def signed_up?(user)
    !user.profiles.empty? && user.profile.valid?
  end

  def username_available?(username)
    username if User.find_by_username(username).nil?
  end

  def make_username(desired_username, fullname = nil)
    unless username = username_available?(desired_username)
      if fullname
        unless username = username_available?(fullname.parameterize)
          username = username_available?(fullname.parameterize.split('-').map{ |name| name.chars.first }.join)
        end
      end
    end
    username ||= "user-#{User.last.id + 1}"
  end

  def social_user?(user)
    user.email.nil? && user.encrypted_password.nil?
  end

  ### errors helpers

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
        when :email_format
          @errors.push "#{attribute} #{t('activerecord.errors.messages.invalid')}" unless value =~ v[:with]
      end
    end
    "#{t('flash.error.base')} #{@errors.to_sentence}." unless @errors.empty?
  end

  def kiss_init
    content_tag(:script, :type => 'text/javascript') do
      "var _kmq = _kmq || [];
      var _kmk = _kmk || 'e8e98ddeeceb420cd63d5953d02ac7558550011a';
      function _kms(u){
        setTimeout(function(){
          var d = document, f = d.getElementsByTagName('script')[0],
          s = d.createElement('script');
          s.type = 'text/javascript'; s.async = true; s.src = u;
          f.parentNode.insertBefore(s, f);
        }, 1);
      }
      _kms('//i.kissmetrics.com/i.js');
      _kms('//doug1izaerwt3.cloudfront.net/' + _kmk + '.1.js');"
    end
  end

  def kiss_event(type, name, options = {})
    content_tag(:script, :type => 'text/javascript') do
      "_kmq.push([#{type}, #{event}, #{options}]);"
    end
  end
end
