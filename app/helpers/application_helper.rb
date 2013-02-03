module ApplicationHelper

  def title
    unless title = @title
      namespace = %w(sessions registrations passwords).include?(controller_name) ? "devise.#{controller_name}" : controller_name
      title = t("#{namespace}.#{action_name}.title")
    end
    "Joblr | #{title}"
  end

  def footer?
    user_signed_in? && current_user.activated?
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

  # Analytics
  # ---------

  def mixpanel_init(environment)
    content_tag(:script, type: 'text/javascript') do
      "(function(e,b){
        if(!b.__SV){
          var a,f,i,g;
          window.mixpanel=b;a=e.createElement('script');
          a.type='text/javascript';
          a.async=!0;
          a.src=('https:'===e.location.protocol?'https:':'http:')+'//cdn.mxpnl.com/libs/mixpanel-2.2.min.js';
          f=e.getElementsByTagName('script')[0];
          f.parentNode.insertBefore(a,f);
          b._i=[];
          b.init=function(a,e,d){
            function f(b,h){
              var a=h.split('.');
              2==a.length&&(b=b[a[0]],h=a[1]);
              b[h]=function(){
                b.push([h].concat(Array.prototype.slice.call(arguments,0)))}}
          var c=b;
          'undefined'!==typeof d?c=b[d]=[]:d='mixpanel';
          c.people=c.people||[];
          c.toString=function(b){
            var a='mixpanel';
            'mixpanel'!==d&&(a+='.'+d);
            b||(a+=' (stub)');
            return a};
          c.people.toString=function(){return c.toString(1)+'.people (stub)'};
          i='disable track track_pageview track_links track_forms register register_once alias unregister identify name_tag set_config people.set people.increment people.append people.track_charge'.split(' ');
          for(g=0;g<i.length;g++)f(c,i[g]);
          b._i.push([a,e,d])};
          b.__SV=1.2}})
      (document,window.mixpanel||[]);
      mixpanel.init('#{mixpanel_key(environment)}');".html_safe
    end
  end

  def mixpanel_call(action, value, properties = nil)
    content_tag(:script, type: 'text/javascript') {"mixpanel.#{action}('#{value}'#{', '+properties if properties});".html_safe} if Rails.env.production? || Rails.env.test?
  end

  def mixpanel_people(user)
    if Rails.env.production? || Rails.env.test?
      content_tag(:script, type: 'text/javascript') {
        "mixpanel.people.set({
          $email: '#{user.email}',
          $name: '#{user.fullname}',
          $username: '#{user.username}',
          $last_login: '#{user.last_sign_in_at}',
          $created: '#{user.created_at}'});".html_safe}
    end
  end

  def mixpanel_key(environment)
    case environment
      when :production
        'b38474fcaddb3625c54dd9e06a1591aa'
      when :staging
        'e70b5bbc81f1c962a60d97a27cfe1552'
    end
  end
end
