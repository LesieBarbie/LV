require_relative 'html_form'

class FormBuilder
  def self.create(action:, method:, &block)
    form = HTMLForm.new(action: action, method: method)
    form.instance_eval(&block)
    form.to_html
  end
end

if __FILE == $0
  form_html = FormBuilder.create(action: "/submit", method: "post") do
    text_field name: "username", placeholder: "Enter your username"
    text_field name: "email", placeholder: "Enter your email"
    checkbox name: "agree_terms", label: "I agree to the terms"
    button text: "Submit"
  end

  puts form_html
end