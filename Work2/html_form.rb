class HTMLForm
  def initialize(action:, method:)
    @action = action
    @method = method
    @fields = []
  end

  def text_field(name:, placeholder: "")
    @fields << "<input type='text' name='#{name}' placeholder='#{placeholder}' />"
  end

  def checkbox(name:, label:)
    @fields << "<label><input type='checkbox' name='#{name}' /> #{label}</label>"
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
