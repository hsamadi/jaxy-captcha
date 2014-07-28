require 'rails/generators'

class JaxyCaptchaGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  def self.source_root
    @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates/'))
  end

  def self.next_migration_number(dirname)
    Time.now.strftime("%Y%m%d%H%M%S")
  end

  def create_captcha_migration
    migration_template "migration.rb", File.join('db/migrate', "create_jaxy_captcha_data.rb")
  end
end
