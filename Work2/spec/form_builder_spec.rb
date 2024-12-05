require_relative '../form_builder'
require_relative '../html_form'

RSpec.describe FormBuilder do
  describe '.create' do
    it 'створює HTML-форму з переданими параметрами' do
      form_html = FormBuilder.create(action: "/submit", method: "post") do
        text_field name: "username", placeholder: "Enter your username", label: "Username", required: true
      end

      expect(form_html).to include('<form action="/submit" method="post"')
      expect(form_html).to include('<input type=\'text\' id=\'username\' name=\'username\' placeholder=\'Enter your username\' required')
    end

    it 'додає заголовок до форми' do
      form_html = FormBuilder.create(action: "/submit", method: "post") do
        heading text: "Test Form", level: 2
      end

      expect(form_html).to include("<h2 style='text-align: center;'>Test Form</h2>")
    end
  end
end
