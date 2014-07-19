require "rubygems"
require "sinatra"
require "sinatra/assetpack"
require "compass"
require "slim"


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

set :public_folder, 'assets'

get '/' do
  slim :home
end

get '/template' do 
  slim :templ
end

