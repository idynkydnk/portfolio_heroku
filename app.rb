require 'sinatra'
require 'slim'
require_relative 'routes/init'

configure do
  enable :sessions
  set :session_secret, "secret"
end

get '/' do
  slim :index
end

