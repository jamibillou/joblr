module CharCounterHelper

  def char_counter_for(object, attribute, options = {})
    "<label class='char-counter #{options[:class] if options[:class]}'>
      0/#{object.class.validators_on(attribute)[0].options[:maximum]}
    </label>".html_safe
  end
end
