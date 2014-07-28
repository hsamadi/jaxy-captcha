module JaxyCaptcha #:nodoc
  module ControllerHelpers #:nodoc
    def jaxy_captcha_valid?(key, text)
      return @_jaxy_captcha_result unless @_jaxy_captcha_result.nil?
      @_jaxy_captcha_result = JaxyCaptchaData::verify(key, text.delete(' '))
    end
  end
end
