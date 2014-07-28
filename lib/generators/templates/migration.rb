class CreateJaxyCaptchaData < ActiveRecord::Migration
  def self.up
    create_table :jaxy_captcha_data do |t|
      t.string :key, :limit => 40
      t.string :value, :limit => 10
      t.boolean :passed, :default => false
      t.timestamps
    end
    
    add_index :jaxy_captcha_data, :key, :name => "idx_key"
  end

  def self.down
    drop_table :jaxy_captcha_data
  end
end
