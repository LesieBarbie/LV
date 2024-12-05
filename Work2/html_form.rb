class HTMLForm
  def initialize(action:, method:)
    @action = action
    @method = method
    @fields = []
  end

  def text_field(name:, placeholder: "", label: nil, required: false)
    label_html = label ? "<label for='#{name}'>#{label}</label>" : ""
    required_attr = required ? "required" : ""
    @fields << <<~HTML
      <div style="margin-bottom: 15px;">
        #{label_html}
        <input type='text' id='#{name}' name='#{name}' placeholder='#{placeholder}' #{required_attr} style="padding: 8px; width: 100%; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px;" />
      </div>
    HTML
  end

  def checkbox(name:, label:)
    @fields << <<~HTML
      <div style="margin-bottom: 15px;">
        <label>
          <input type='checkbox' name='#{name}' style="margin-right: 5px;" /> #{label}
        </label>
      </div>
    HTML
  end

  def button(text:, type: "submit")
    @fields << "<button type='#{type}'>#{text}</button>"
  end

  def to_html
    <<~HTML
      <form action="#{@action}" method="#{@method}">
        #{@fields.join("\n")}
      </form>
    HTML
  end
end
