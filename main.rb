require 'sinatra'
require 'slim'
require_relative 'routes/init'

get '/' do
  slim :index
end

get '/hangman' do
  slim :hangman
end
