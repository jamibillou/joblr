# Removes the default rails error handling on input and label
# Relies on the Nokogiri gem.
# Credit to https://github.com/ripuk

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html = %(<div class="field_with_errors">#{html_tag}</div>).html_safe
  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, input"
  elements.each do |e|
    if e.node_name.eql? 'label'
      html = %(#{e}).html_safe
    elsif e.node_name.eql? 'input'
      html = %(#{e}).html_safe
    end
  end
  html
end