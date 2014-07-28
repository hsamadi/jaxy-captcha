# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jaxy_captcha/version"

Gem::Specification.new do |s|
  s.name = "jaxy_captcha"
  s.version = JaxyCaptcha::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.summary = "JaxyCaptcha is a fork of SimpleCaptcha2 gem with many project-specific customizations."
  s.description = "JaxyCaptcha is only working with Rails 3. It is not backward compatible with any previous versions of Rails."
  s.authors = ["Hussein Samadi"]
  s.email = "hs.samadi@gmail.com"
  s.homepage = "http://github.com/hsamadi/jaxy-captcha"

  s.files = Dir["{lib}/**/*"] + ["Rakefile", "README.md"]
  s.extra_rdoc_files = ["README.md"]
  s.require_paths = ["lib"]

  s.add_dependency 'rails', '>= 3.2'
end
