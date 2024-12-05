require 'rspec'
require_relative 'html_form'

RSpec.describe HTMLForm do
  let(:form) { HTMLForm.new(action: "/submit", method: "post") }

  describe '#heading' do
    it 'adds a heading to the form' do
      form.heading(text: "Test Heading", level: 2)
      expect(form.to_html).to include("<h2 style='text-align: center;'>Test Heading</h2>")
    end
  end

  describe '#text_field' do
    it 'adds a text field with a label' do
      form.text_field(name: "username", placeholder: "Enter your username", label: "Username", required: true)
      expect(form.to_html).to include("<label for='username' style='display: block; margin-bottom: 5px;'>Username</label>")
      expect(form.to_html).to include("<input type='text' id='username' name='username' placeholder='Enter your username' required")
    end
  end

  describe '#email_field' do
    it 'adds an email field with the specified attributes' do
      form.email_field(name: "email", placeholder: "Enter your email", label: "Email", required: true)
      expect(form.to_html).to include("<input type='email' id='email' name='email' placeholder='Enter your email' required")
    end
  end

  describe '#password_field' do
    it 'adds a password field to the form' do
      form.password_field(name: "password", placeholder: "Enter your password", label: "Password", required: true)
      expect(form.to_html).to include("<input type='password' id='password' name='password' placeholder='Enter your password' required")
    end
  end

  describe '#select_field' do
    it 'adds a dropdown select field with options' do
      form.select_field(name: "country", label: "Country", options: ["USA", "Canada"])
      expect(form.to_html).to include("<select id='country' name='country'")
      expect(form.to_html).to include("<option value='usa'>USA</option>")
      expect(form.to_html).to include("<option value='canada'>Canada</option>")
    end
  end

  describe '#radio_group' do
    it 'adds a radio button group with options' do
      form.radio_group(name: "gender", label: "Gender", options: { male: "Male", female: "Female" })
      expect(form.to_html).to include("<input type='radio' id='gender_male' name='gender' value='male'")
      expect(form.to_html).to include("<label for='gender_male'>")
    end
  end

  describe '#checkbox' do
    it 'adds a checkbox field with a label' do
      form.checkbox(name: "agree_terms", label: "Agree to terms", required: true)
      expect(form.to_html).to include("<input type='checkbox' id='agree_terms' name='agree_terms' required")
    end
  end

  describe '#button' do
    it 'adds a submit button' do
      form.button(text: "Submit", style: "background: green; color: white;")
      expect(form.to_html).to include("<button type='submit' style='background: green; color: white;'>Submit</button>")
    end

    it 'adds a link button' do
      form.button(text: "Learn More", link: "https://example.com", style: "color: blue;")
      expect(form.to_html).to include("<a href='https://example.com' style='color: blue;'>Learn More</a>")
    end
  end
end

RSpec.describe FormBuilder do
  describe '.create' do
    it 'creates an HTML form based on the provided DSL block' do
      form_html = FormBuilder.create(action: "/submit", method: "post") do
        heading text: "Test Form", level: 2
        text_field name: "username", placeholder: "Enter your username", label: "Username", required: true
      end

      expect(form_html).to include("<form action=\"/submit\" method=\"post\"")
      expect(form_html).to include("<h2 style='text-align: center;'>Test Form</h2>")
      expect(form_html).to include("<input type='text' id='username' name='username' placeholder='Enter your username' required")
    end
  end
end
# frozen_string_literal: true

