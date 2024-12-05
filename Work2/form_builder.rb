require_relative 'html_form'

# Клас для створення форми через DSL
class FormBuilder
  def self.create(action:, method:, &block)
    new_form(action: action, method: method, &block).to_html
  end

  def self.new_form(action:, method:, &block)
    form = HTMLForm.new(action: action, method: method)
    form.instance_eval(&block)
    form
  end
end

# Приклад використання DSL
if __FILE__ == $0
  form_html = FormBuilder.create(action: "/submit", method: "post") do
    heading text: "User Registration Form", level: 2
    text_field name: "username", placeholder: "Enter your username", label: "Username", required: true
    email_field name: "email", placeholder: "Enter your email", label: "Email Address", required: true
    password_field name: "password", placeholder: "Enter your password", label: "Password", required: true
    select_field name: "country", label: "Country", options: ["United States", "Canada", "United Kingdom", "Ukraine"]
    radio_group name: "gender", label: "Gender", options: { male: "Male", female: "Female", other: "Other" }
    checkbox name: "agree_terms", label: "I agree to the terms and conditions", required: true
    button text: "Register", style: "background-color: #4CAF50; color: white; padding: 10px 20px; border: none; cursor: pointer;"
  end

  puts form_html
end
