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

  # Analytics
  # ---------

  def mixpanel_init
    if Rails.env.production?
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
        mixpanel.init('b38474fcaddb3625c54dd9e06a1591aa');".html_safe
      end
    end
  end

  def mixpanel_event(value)
    content_tag(:script, type: 'text/javascript') {"mixpanel.track('#{value}');".html_safe}
  end

  def mixpanel_identify(id)
    content_tag(:script, type: 'text/javascript') {"mixpanel.identify('#{id}');".html_safe}
  end

  def mixpanel_people(user)
    if Rails.env.production? || Rails.env.test?
      content_tag(:script, type: 'text/javascript') {
        "mixpanel.people.set({
          $email: '#{user.email}',
          $name: '#{user.fullname}',
          $last_login: '#{user.last_sign_in_at}',
          $username: '#{user.username}'});".html_safe}
    end
  end  

  def kiss_init(environment)
    content_tag(:script, :type => 'text/javascript') do
      "var _kmq = _kmq || [];
      var _kmk = _kmk || '#{kiss_key(environment)}';
      function _kms(u){
        setTimeout(function(){
          var d = document, f = d.getElementsByTagName('script')[0],
          s = d.createElement('script');
          s.type = 'text/javascript'; s.async = true; s.src = u;
          f.parentNode.insertBefore(s, f);
        }, 1);
      }
      _kms('//i.kissmetrics.com/i.js');
      _kms('//doug1izaerwt3.cloudfront.net/' + _kmk + '.1.js');".html_safe
    end
  end

  def kiss_event(type, value)
    content_tag(:script, :type => 'text/javascript') { "_kmq.push(['#{type}', '#{value}']);".html_safe } if Rails.env.production? || Rails.env.test?
  end

  def kiss_key(environment)
    case environment
      when :production
        'e8e98ddeeceb420cd63d5953d02ac7558550011a'
      when :staging
        '970f5363f87388ae16820996704438e1bedb68c2'
    end
  end
end
