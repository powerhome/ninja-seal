require 'sinatra'
require 'json'
require 'byebug'
require 'rack/parser'
require 'dotenv'
require './github_webhook'

module NinjaSeal
  class App < Sinatra::Base
    use Rack::Parser, parsers: {
      'application/json' => -> (data) { JSON.parse(data) }
    }

    use GithubWebhook

    post '/webhooks/tracker' do
      'Put this in your pipe & smoke it!'
    end

    run!
  end
end
