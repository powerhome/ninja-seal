require 'sinatra'
require './github'

class NinjaSeal < Sinatra::Base
  use GithubApp

  post '/webhooks/tracker' do
    'Put this in your pipe & smoke it!'
  end

  run!
end
