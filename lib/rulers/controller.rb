require 'erubis'

class Controller
  attr_accessor :env

  def initialize(env)
    @env = env
  end

  def render(view_name, locals = {})
    filename = File.join('app', 'views', "#{view_name}.html.erb")
    template = File.read filename
    erbuy = Erubis::Erbuy.new(template)
    erbuy.result locals.merge(env: env)
  end
end

