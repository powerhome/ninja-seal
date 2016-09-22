require 'sinatra'
require 'json'
require 'byebug'
require 'rack/parser'
require 'dotenv'
require 'tracker_api'
require 'erubis'
require './github'

if ENV.has_key? 'RACK_ENV'
  env_file = File.expand_path("../.#{ENV['RACK_ENV']}.env", __FILE__)
else
  env_file = File.expand_path('../.env', __FILE__)
end

Dotenv.load env_file

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
      stories = tracker.projects.map do |project|
        [project.name, project.stories(with_state: :finished)]
      end

      erb :stories, locals: { projects: Hash[stories] }
    end

    run! if app_file == $0
  end
end
