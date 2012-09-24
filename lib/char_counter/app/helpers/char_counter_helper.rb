module CharCounterHelper

  def char_counter_for(object, attribute, options = {})
    "<small class='char-counter #{options[:class] if options[:class]}'>
      0/#{object.class.validators_on(attribute)[0].options[:maximum]}
    </small>".html_safe
  end
end
