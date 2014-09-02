require "rubygems"
require "sinatra"
require "sinatra/flash"
require "sinatra/assetpack"
require "compass"
require "slim"
require "warden"
require "bcrypt"
require "font-awesome-sass"
require "./eye_test"
require "./call_me_back"
require "./users"

set :raise_errors, true
set :show_exceptions, true

enable :sessions
set :session_secret, "j1U*ds@32$-U9i0oPgG-=m.$45R@%e42"

use Warden::Manager do |config|
  config.serialize_into_session{ |user| user.id }
  config.serialize_from_session{ |id|   User.get(id) }

  config.scope_defaults :default,
    strategies: [:password],
    action: '/auth/unauthenticated'
  config.failure_app = self
end

Warden::Manager.before_failure do |env,opts|
  env['REQUEST_METHOD'] = 'POST'
end

Warden::Strategies.add(:password) do
  def valid?
    params['user']['username'] && params['user']['password']
  end

  def authenticate!
    user = User.first(username: params['user']['username'])
    if user.nil?
      fail!("The username you entered does not exist.")
    elsif user.authenticate(params['user']['password'])
      success!(user)
    else
      fail!("Could not log in")
    end
  end

end

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

def choose_name(username)  
  which_username = username
  case which_username
    when 'admin'
      {:showroom_index => 0..4}
    when 'gallery'
      {:showroom_index => 0..1}
    when 'k6'
      {:showroom_index => 1}
    when 'mayak'
      {:showroom_index => 2}
    when 'plaza'
      {:showroom_index => 3}
    when 'city'
      {:showroom_index => 4}
  end
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

get '/auth/login' do
  slim :'admin/login'
end

get '/admin' do
    env['warden'].authenticate!
    @current_user = env['warden'].user
    @username = @current_user.username
    if @username == 'admin'
      slim :'admin/admin', :layout => :'admin/admin_layout'
    else
      slim :'admin/tickets', :layout => :'admin/admin_layout'
    end
end

post '/auth/login' do
  env['warden'].authenticate!

  if session[:return_to].nil?
    redirect '/admin'
  else
    redirect session[:return_to]
  end

end

get '/auth/logout' do
  env['warden'].raw_session.inspect
  env['warden'].logout
  redirect '/'
end

post '/auth/unauthenticated' do
  session[:return_to] = env['warden.options'][:attempted_path]
  puts env['warden.options'][:attempted_path]
  redirect '/auth/login'
end

get '/protected' do
  env['warden'].authenticate!
  @current_user = env['warden'].user
  erb :protected
end

