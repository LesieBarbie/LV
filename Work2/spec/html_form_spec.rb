require_relative '../html_form'

RSpec.describe HTMLForm do
  let(:form) { HTMLForm.new(action: "/test", method: "post") }

  describe '#heading' do
    it 'додає заголовок до форми' do
      form.heading(text: "Test Heading", level: 2)
      html = form.to_html

      expect(html).to include("<h2 style='text-align: center;'>Test Heading</h2>")
    end
  end

  describe '#text_field' do
    it 'додає текстове поле до форми' do
      form.text_field(name: "username", placeholder: "Enter your username", label: "Username", required: true)
      html = form.to_html

      expect(html).to include("<label for='username'")
      expect(html).to include("<input type='text' id='username' name='username' placeholder='Enter your username' required")
    end
  end

  describe '#email_field' do
    it 'додає поле для введення email' do
      form.email_field(name: "email", placeholder: "Enter your email", label: "Email", required: true)
      html = form.to_html

      expect(html).to include("<input type='email' id='email'")
      expect(html).to include("placeholder='Enter your email'")
    end
  end

  describe '#select_field' do
    it 'додає випадаючий список до форми' do
      form.select_field(name: "country", label: "Country", options: ["Ukraine", "USA"])
      html = form.to_html

      expect(html).to include("<select id='country'")
      expect(html).to include("<option value='ukraine'>Ukraine</option>")
      expect(html).to include("<option value='usa'>USA</option>")
    end
  end

  describe '#radio_group' do
    it 'додає групу радіо-кнопок до форми' do
      form.radio_group(name: "gender", label: "Gender", options: { male: "Male", female: "Female" })
      html = form.to_html

      expect(html).to include("<input type='radio' id='gender_male'")
      expect(html).to include("<input type='radio' id='gender_female'")
    end
  end

  describe '#checkbox' do
    it 'додає чекбокс до форми' do
      form.checkbox(name: "agree_terms", label: "Agree to terms", required: true)
      html = form.to_html

      expect(html).to include("<input type='checkbox' id='agree_terms'")
      expect(html).to include("Agree to terms")
    end
  end

  describe '#button' do
    it 'додає кнопку до форми' do
      form.button(text: "Submit", style: "color: red;")
      html = form.to_html

      expect(html).to include("<button type='submit' style='color: red;'>Submit</button>")
    end

    it 'додає посилання у вигляді кнопки до форми' do
      form.button(text: "Go to Google", style: "color: blue;", link: "https://google.com")
      html = form.to_html

      expect(html).to include("<a href='https://google.com' style='color: blue;'>Go to Google</a>")
    end
  end
end
