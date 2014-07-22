require "rubygems"
require "sinatra"
require "sinatra/flash"
require "sinatra/assetpack"
require "compass"
require "slim"
require "./eye_test"

enable :sessions

helpers do 

  def set_showrooms
    @showrooms = [
      "ТЦ Галерея, Троицкий д.12, г. Архангельск",
      "Комсомольский, ул. Комсомольская д.6 г. Архангельск",
      "ТЦ Плаза, г. Мирный, ул. Циргвава д.8"
    ]
  end

end

assets do
  serve '/js', from: 'js'
  serve '/bower_components', from: 'bower_components'

  js :modernizr, [
    '/bower_components/modernizr/modernizr.js',
  ]

  js :libs, [
    '/bower_components/jquery/dist/jquery.js',
    '/bower_components/foundation/js/foundation.js'
  ]

  js :application, [
    '/js/jquery.hc-sticky.min.js',
    '/js/app.js'
  ]

  js_compression :jsmin
end

before do 
  set_showrooms
end

set :public_folder, 'assets'

get '/' do
  slim :home
end

get '/template' do 
  slim :templ
end

