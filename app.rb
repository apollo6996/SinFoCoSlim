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
      "ТЦ Галерея, Троицкий д.10, г. Архангельск",
      "Комсомольский, ул. Комсомольская д.6, г. Архангельск",
      "ТЦ Маяк, Никольский проспект, 35, г. Архангельск",
      "г. Мирный, ТЦ Плаза, ул. Циргвава д.8",
      "г. Северодвинск, ТЦ Сити, Морской проспект д.70"
    ]
  end

  def set_short_showrooms
    @short_showrooms = {
      @showrooms[0] => "Галерея",
      @showrooms[1] => "Комсомольский",
      @showrooms[2] => "Маяк",
      @showrooms[3] => "Плаза",
      @showrooms[4] => "Сити"
    }
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
  set_short_showrooms
  show_testers
end

set :public_folder, 'assets'

get '/' do
  slim :home
end

get '/getsignupform' do
  slim :signup_body
end

get '/template' do 
  slim :templ
end

