module JaxyCaptcha
  class JaxyCaptchaData < ActiveRecord::Base

    self.table_name = "jaxy_captcha_data"

    attr_protected

    class << self
      def get_instance(key)
        where(key: key, passed: false).first || new(key: key)
      end

      def verify(key, value)
        where(key: key, passed: false)
          .where('LOWER(value) = ?', value.downcase)
          .update_all(passed: true) > 0
      end
    end
  end
end
