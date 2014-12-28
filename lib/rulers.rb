require "rulers/version"
require "rulers/routing"

module Rulers

  class Application
    def call(env)
      return [404, {'Content-Type' => 'text/html'}, []] if env['PATH_INFO'] == '/favicon.ico'
      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      begin
        text = controller.send(act)
      rescue
        return [500, {'Content-Type' => 'text/html'},
         "There was an error"]
      end
      [200, {'Content-Type' => 'text/html'},
        [text]]
    end
  end

  class Controller
    attr_accessor :env

    def initialize(env)
      @env = env
    end
  end

end
