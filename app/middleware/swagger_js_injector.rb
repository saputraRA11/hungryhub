# frozen_string_literal: true

class SwaggerJsInjector
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)

    # Only inject into the Swagger UI index page
    path = env['PATH_INFO'] || ''
    if path =~ %r{^/api-docs/?(index\.html)?$} || path == '/api-docs' || path == '/api-docs/'
      content_type = headers['content-type'] || headers['Content-Type'] || ''
      if content_type.include?('text/html')
        body = ''
        response.each { |part| body << part }
        response.close if response.respond_to?(:close)

        # Inject custom script tag before </body>
        script_tag = '<script src="/swagger_custom.js"></script>'
        if body.include?('</body>')
          body.sub!('</body>', "#{script_tag}\n</body>")
        else
          body << script_tag
        end

        headers['Content-Length'] = body.bytesize.to_s
        return [status, headers, [body]]
      end
    end

    [status, headers, response]
  end
end
