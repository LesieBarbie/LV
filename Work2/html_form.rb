class HTMLForm
  def initialize(action:, method:)
    @action = action
    @method = method
    @fields = []
  end

  def heading(text:, level: 1)
    @fields << "<h#{level} style='text-align: center;'>#{text}</h#{level}>"
  end

  def text_field(name:, placeholder: "", label: nil, required: false)
    add_field_with_label(name, label) do
      "<input type='text' id='#{name}' name='#{name}' placeholder='#{placeholder}' #{required_attr(required)} style='#{input_style}' />"
    end
  end

  def email_field(name:, placeholder: "", label: nil, required: false)
    add_field_with_label(name, label) do
      "<input type='email' id='#{name}' name='#{name}' placeholder='#{placeholder}' #{required_attr(required)} style='#{input_style}' />"
    end
  end

  def password_field(name:, placeholder: "", label: nil, required: false)
    add_field_with_label(name, label) do
      "<input type='password' id='#{name}' name='#{name}' placeholder='#{placeholder}' #{required_attr(required)} style='#{input_style}' />"
    end
  end

  def select_field(name:, label: nil, options: [])
    options_html = options.map { |opt| "<option value='#{opt.downcase.gsub(' ', '_')}'>#{opt}</option>" }.join
    add_field_with_label(name, label) do
      "<select id='#{name}' name='#{name}' style='#{input_style}'>#{options_html}</select>"
    end
  end

  def radio_group(name:, label:, options: {})
    options_html = options.map do |value, label_text|
      "<label><input type='radio' name='#{name}' value='#{value}' style='margin-right: 5px;' /> #{label_text}</label>"
    end.join("<br>")
    add_field_with_label(name, label) { options_html }
  end

  def checkbox(name:, label:, required: false)
    @fields << <<~HTML
      <div style="margin-bottom: 15px;">
        <label>
          <input type='checkbox' id='#{name}' name='#{name}' #{required_attr(required)} style="margin-right: 5px;" /> #{label}
        </label>
      </div>
    HTML
  end
