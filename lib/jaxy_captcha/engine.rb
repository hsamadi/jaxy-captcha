# encoding: utf-8

module JaxyCaptcha
  class Engine < Rails::Engine
    config.app_middleware.use JaxyCaptcha::Middleware
  end
end
