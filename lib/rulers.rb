require "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"

module Rulers

  class Application
    def call(env)
      return [404, {'Content-Type' => 'text/html'}, []] if env['PATH_INFO'] == '/favicon.ico'
      controller_class, action_name = get_controller_and_action(env)
      controller = controller_class.new(env)
      begin
        text = controller.send(action_name)
      rescue
        return [500, {'Content-Type' => 'text/html'},
                ["There was an error"]]
      end
      [200, {'Content-Type' => 'text/html'},
       [text]]
    end
  end

end
