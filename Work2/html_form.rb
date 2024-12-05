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
      unique_id = "#{name}_#{value}" # Унікальний id для кожної кнопки
      <<~HTML
        <label for='#{unique_id}'>
          <input type='radio' id='#{unique_id}' name='#{name}' value='#{value}' style='margin-right: 5px;' /> #{label_text}
        </label>
      HTML
    end.join("<br>")

    @fields << <<~HTML
      <div style="margin-bottom: 15px;">
        <span style='display: block; margin-bottom: 5px;'>#{label}</span>
        #{options_html}
      </div>
    HTML
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

  def button(text:, type: "submit", style: "", link: nil, margin_top: "20px")
    if link
      @fields << <<~HTML
      <div style="text-align: center; margin-top: #{margin_top};">
        <a href='#{link}' style='#{style}'>#{text}</a>
      </div>
    HTML
    else
      @fields << <<~HTML
      <div style="text-align: center; margin-top: #{margin_top};">
        <button type='#{type}' style='#{style}'>#{text}</button>
      </div>
    HTML
    end
  end

  def to_html
    <<~HTML
      <form action="#{@action}" method="#{@method}" style="max-width: 500px; margin: 0 auto; padding: 20px; border: 1px solid #ccc; border-radius: 10px; background-color: #f9f9f9;">
        #{@fields.join("\n")}
      </form>
    HTML
  end

  private

  def input_style
    "padding: 10px; width: 100%; box-sizing: border-box; border: 1px solid #ccc; border-radius: 5px;"
  end

  def required_attr(required)
    required ? "required" : ""
  end

  def add_field_with_label(name, label)
    label_html = label ? "<label for='#{name}' style='display: block; margin-bottom: 5px;'>#{label}</label>" : ""
    @fields << <<~HTML
      <div style="margin-bottom: 15px;">
        #{label_html}
        #{yield}
      </div>
    HTML
  end
end
