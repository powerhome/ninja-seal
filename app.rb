require 'sinatra'
require 'rack/parser'
require './github_webhook'

module NinjaSeal
  class App < Sinatra::Base
    use Rack::Parser, content_types: {
      'application/json' => JSON.method(:parse)
    }

    use GithubWebhook

    post '/webhooks/tracker' do
      'Put this in your pipe & smoke it!'
    end

    run!
  end
end
