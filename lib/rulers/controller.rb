require 'erubis'
require 'rulers/file_model'

module Rulers
  class Controller
    include Rulers::Model
    attr_accessor :env

    def initialize(env)
      @env = env
    end

    def render(view_name, locals = {})
      filename = File.join('app', 'views', "#{view_name}.html.erb")
      template = File.read filename
      erbuy = Erubis::Eruby.new(template)
      erbuy.result locals.merge(env: env)
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      request.params
    end

    def response(text, status=200, headers = {})
      raise "Already responded!" if @response
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end

    def get_response
      @response
    end

    def render_response(*args)
      response(render(*args))
    end

  end
end

