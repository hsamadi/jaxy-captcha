require 'tempfile'

module JaxyCaptcha #:nodoc
  module ImageHelpers #:nodoc

    mattr_accessor :image_styles
    @@image_styles = {
      'embosed_silver'  => ['-fill darkblue', '-shade 20x60', '-background white'],
      'simply_red'      => ['-fill darkred', '-background white'],
      'simply_green'    => ['-fill darkgreen', '-background white'],
      'simply_blue'     => ['-fill darkblue', '-background white'],
      'distorted_black' => ['-fill darkblue', '-edge 10', '-background white'],
      'all_black'       => ['-fill darkblue', '-edge 2', '-background white'],
      'charcoal_grey'   => ['-fill darkblue', '-charcoal 5', '-background white'],
      'almost_invisible' => ['-fill red', '-solarize 50', '-background white']
    }

    DISTORTIONS = ['low', 'medium', 'high']

    IMPLODES = { 'none' => 0, 'low' => 0.1, 'medium' => 0.2, 'high' => 0.3 }
    DEFAULT_IMPLODE = 'medium'

    class << self

      def image_params(key = 'simply_blue')
        image_keys = @@image_styles.keys

        style = begin
          if key == 'random'
            image_keys[rand(image_keys.length)]
          else
            image_keys.include?(key) ? key : 'simply_blue'
          end
        end

        @@image_styles[style]
      end

      def distortion(key='low')
        key =
          key == 'random' ?
          DISTORTIONS[rand(DISTORTIONS.length)] :
          DISTORTIONS.include?(key) ? key : 'low'
        case key.to_s
          when 'low' then return [0 + rand(2), 80 + rand(20)]
          when 'medium' then return [2 + rand(2), 50 + rand(20)]
          when 'high' then return [4 + rand(2), 30 + rand(20)]
        end
      end

      def implode
        IMPLODES[JaxyCaptcha.implode] || IMPLODES[DEFAULT_IMPLODE]
      end
    end

    private

      def generate_captcha_image(text) #:nodoc
        amplitude, frequency = ImageHelpers.distortion(JaxyCaptcha.distortion)
        width, height = JaxyCaptcha.image_size.split('x')

        params = ImageHelpers.image_params(JaxyCaptcha.image_style).dup
        params << "-size #{JaxyCaptcha.image_size}"
        params << "-wave #{amplitude}x#{frequency}"
        params << "-gravity \"Center\""
        params << "-pointsize #{width.to_i / 5.0}"
        params << "-implode #{ImageHelpers.implode}"

        dst = Tempfile.new(['jaxy_captcha', '.jpg'], JaxyCaptcha.tmp_path)
        dst.binmode

        params << "label:#{text} \"#{File.expand_path(dst.path)}\""

        JaxyCaptcha::Utils::run("convert", params.join(' '))

        dst.close

        File.expand_path(dst.path)
        #dst
      end
  end
end
