# Source: https://gist.github.com/andreimoment/515715d9d56ffbdadc25697d9db52c62
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html = ""
  form_fields = %w(textarea input select)
  tag_elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, " + form_fields.join(", ")

  tag_elements.each do |e|
    if e.node_name.eql? "label"
      html = %(#{e}).html_safe
    elsif form_fields.include? e.node_name
      e["class"] = %(#{e["class"]} is-invalid)
      html = %(#{e}).html_safe
    end
  end

  html
end
