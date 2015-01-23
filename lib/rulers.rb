require "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"
require "rulers/file_model"

module Rulers

  class Application
    def call(env)
      return [404, {'Content-Type' => 'text/html'}, []] if env['PATH_INFO'] == '/favicon.ico'
      controller_class, action_name = get_controller_and_action(env)
      controller = controller_class.new(env)
      begin
        text = controller.send(action_name)
        if controller.get_response
          st, hd, rs = controller.get_response.to_a
          [st, hd, [rs.body].flatten]
        else
          [200, {'Content-Type' => 'text/html'},
           [text]]
        end
      rescue Exception => e
        p e
        p e.backtrace
        [500, {'Content-Type' => 'text/html'},
         ["There was an error"]]
      end
    end
  end

end
