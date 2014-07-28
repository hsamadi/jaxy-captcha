# encoding: utf-8

module JaxyCaptcha
  autoload :Utils,             'jaxy_captcha/utils'
  autoload :ImageHelpers,      'jaxy_captcha/image'
  autoload :ControllerHelpers, 'jaxy_captcha/controller'
  autoload :JaxyCaptchaData,   'jaxy_captcha/jaxy_captcha_data'
  autoload :Generator,         'jaxy_captcha/generator'
  autoload :Middleware,        'jaxy_captcha/middleware'

  mattr_accessor :image_size
  @@image_size = "100x28"

  mattr_accessor :length
  @@length = 5

  mattr_accessor :chars
  @@chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  # 'embosed_silver',
  # 'simply_red',
  # 'simply_green',
  # 'simply_blue',
  # 'distorted_black',
  # 'all_black',
  # 'charcoal_grey',
  # 'almost_invisible'
  # 'random'
  mattr_accessor :image_style
  @@image_style = 'simply_blue'

  # 'low', 'medium', 'high', 'random'
  mattr_accessor :distortion
  @@distortion = 'low'

  # 'none', 'low', 'medium', 'high'
  mattr_accessor :implode
  @@implode = JaxyCaptcha::ImageHelpers::DEFAULT_IMPLODE

  # command path
  mattr_accessor :image_magick_path
  @@image_magick_path = ''

  # tmp directory
  mattr_accessor :tmp_path
  @@tmp_path = nil

  # captcha mount path
  mattr_accessor :captcha_path
  @@captcha_path = 'jaxy_captcha'

  def self.add_image_style(name, params = [])
    JaxyCaptcha::ImageHelpers.image_styles.update(name.to_s => params)
  end

  def self.setup
    yield self
  end
end

require 'jaxy_captcha/engine' if defined?(Rails)
