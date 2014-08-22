# encoding: utf-8

module JaxyCaptcha
  class Middleware
    include JaxyCaptcha::ImageHelpers

    DEFAULT_SEND_FILE_OPTIONS = {
      :type         => 'application/octet-stream'.freeze,
      :disposition  => 'attachment'.freeze,
    }.freeze

    def initialize(app, options={})
      @app = app
      @path = JaxyCaptcha.mount_at
      @host = JaxyCaptcha.host
      self
    end

    def call(env) # :nodoc:
      if env["REQUEST_METHOD"] == "GET" && captcha_path?(env['PATH_INFO'])
        request = Rack::Request.new(env)


        if captcha_image_path?(request.path_info)
          make_image(env)
        elsif captcha_path?(request.path_info)
          generate_captcha(env)
        else
          @app.call(env)
        end
      else
        @app.call(env)
      end
    end

    protected
      def captcha_image_path?(request_path)
        request_path.start_with?("#{@path}_image")
      end

      def captcha_path?(request_path)
        request_path.start_with?(@path)
      end

      def captcha_image_url(env, key)
        basepath = File.join('/', "#{@path}_image")
        "#{basepath}?c=#{key}"
      end

      def make_image(env, headers = {}, status = 404)
        request = Rack::Request.new(env)
        return bad_request(env) unless request.params.present? && request.params['c'].present?

        code = request.params['c']
        value = JaxyCaptchaData::get_instance(code).try(:value)
        if value
          send_file(generate_captcha_image(value), :type => 'image/jpeg', :disposition => 'inline', :filename =>  'jaxy_captcha.jpg')
        else
          bad_request(env)
        end
      end

      def send_file(path, options = {})
        raise MissingFile, "Cannot read file #{path}" unless File.file?(path) and File.readable?(path)

        options[:filename] ||= File.basename(path) unless options[:url_based_filename]

        status = options[:status] || 200
        headers = {"Content-Disposition" => "#{options[:disposition]}; filename='#{options[:filename]}'", "Content-Type" => options[:type], 'Content-Transfer-Encoding' => 'binary', 'Cache-Control' => 'private'}
        response_body = File.open(path, "rb")

        [status, headers, response_body]
      end

      def bad_request(env)
        status = 400
        headers = {
          'Content-Type' => 'text/html; charset=utf-8'
        }
        body = <<-EOT
<html><head></head><body><pre>An error occurred:

Input error: c: Error parsing captcha challenge token.
</pre></body></html>
        EOT
        [status, headers, [body]]
      end

      def generate_captcha(env)
        status = 200
        headers = { 'Content-Type' => 'application/json' }
        key = Generator::make_captcha
        
        body = {
          image: captcha_image_url(env, key),
          code: key
        }.to_json

        [status, headers, [body]]
      end
  end
end
