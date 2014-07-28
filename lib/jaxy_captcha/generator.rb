module JaxyCaptcha
  module Generator
    def self.make_captcha
      captcha = nil
      begin
        text = generate_random_text
        key = Digest::SHA1.hexdigest(text + rand(100000).to_s)
        captcha = JaxyCaptchaData.get_instance(key)
      end while captcha.nil?
      captcha.value = text
      captcha.save
      key
    end

    def self.generate_random_text
      chars = JaxyCaptcha.chars
      length = JaxyCaptcha.length
      text = ''
      length.times { text << chars[rand(chars.length)] }
      text
    end
    private_class_method :generate_random_text
  end
end