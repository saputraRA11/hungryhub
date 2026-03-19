# frozen_string_literal: true

class SwaggerJsInjector
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)

    path = env['PATH_INFO'] || ''
    
    # Only inject into the Swagger UI index page
    # Robust matching for /api-docs, /api-docs/, and /api-docs/index.html
    if path.start_with?('/api-docs') && (path.end_with?('/') || path.end_with?('/index.html') || path == '/api-docs')
      content_type = headers['content-type'] || headers['Content-Type'] || ''
      
      if content_type.include?('text/html')
        Rails.logger.info "[SwaggerJsInjector] Matching path found: #{path}. Injecting script..."
        
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
        # Ensure we return a new Rack-compatible response
        return [status, headers, [body]]
      end
    end

    [status, headers, response]
  end
end
