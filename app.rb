require 'sinatra'
require 'json'
require 'byebug'
require 'rack/parser'
require 'dotenv'
require 'tracker_api'
require 'erubis'
require './github'

Dotenv.load(
  File.expand_path("../.#{ENV['RACK_ENV']}.env", __FILE__),
  File.expand_path('../.env', __FILE__)
)

module NinjaSeal
  class App < Sinatra::Base
    set :erb, escape_html: true
    set :views, 'views'

    tracker = TrackerApi::Client.new(token: ENV['TRACKER_API_TOKEN'])

    use Rack::Parser, parsers: {
      'application/json' => -> (data) { JSON.parse(data) }
    }

    use Github

    get '/stories' do
      stories = tracker.projects
        .map{ |project| project.stories(with_state: :finished) }.flatten
        .map{ |story| { id: story.id, title: story.name, state: story.current_state }}

      erb :stories, locals: { stories: stories }
    end

    run! if app_file == $0
  end
end
