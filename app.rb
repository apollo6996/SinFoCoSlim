require "rubygems"
require "sinatra"
require "sinatra/flash"
require "sinatra/assetpack"
require "compass"
require "slim"
require "./eye_test"
require "./call_me_back"
require "font-awesome-sass"

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

  def set_contacts
    @contacts = [
      {},
      { name:   '"Галерея"',
        city:   "г. Архангельск",
        adress: 'Троицкий проспект д.10, ТЦ "Галерея", <br> 2 этаж',
        phone:  "+7 911 552-40-80",
        email:  "gallery@eyevita.ru"
      },

      { name:   '"Комсомольский"',
        city:   "г. Архангельск",
        adress: "ул. Комсомольская д.6, 2 этаж, <br> вход через крыльцо 'Петровский'",
        phone:  "+7 911 552-40-80",
        email:  "k6@eyevita.ru"
      },

      { name:   '"Маяк"',
        city:   "г. Архангельск",
        adress: 'Никольский проспект, 35, ТЦ "Маяк"',
        phone:  "+7 911 552-40-80",
        email:  "mayak@eyevita.ru"
      },

      { name:   '"Плаза"',
        city:   "г. Мирный",
        adress: 'ул. Циргвава д.8, ТЦ "Плаза"',
        phone:  "+7 911 552-40-80",
        email:  "plaza@eyevita.ru"
      },

      { name:   '"Сити"',
        city:   "г. Северодвинск",
        adress: 'Морской проспект д.70, ТЦ "Сити"',
        phone:  "+7 911 552-40-80",
        email:  "city@eyevita.ru"
      }
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
  set_short_showrooms
  show_testers
  show_callbacks_requests
  set_contacts
end

set :public_folder, 'assets'

get '/' do
  slim :home
end

get '/geteyetest_form' do
  slim :eyetest_form
end

get '/getcallmeback_form' do
  slim :callmeback_form
end

get '/thankyou' do
  slim :ty
end

get '/template' do 
  slim :templ
end

