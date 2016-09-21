require 'sinatra'
require 'json'
require 'byebug'
require 'rack/parser'
require 'dotenv'
require 'tracker_api'
require './github_webhook'
require 'erubis'

module NinjaSeal
  class App < Sinatra::Base
    set :erb, escape_html: true
    set :views, 'views'

    tracker = TrackerApi::Client.new(token: ENV['TRACKER_API_TOKEN'])

    use Rack::Parser, parsers: {
      'application/json' => -> (data) { JSON.parse(data) }
    }

    use GithubWebhook

    get '/stories' do
      items = []
      tracker.projects.each do |project|
        project.stories(with_state: :finished).each do |story|
          items << { id: story.id, title: story.name, state: story.current_state }
        end
      end
      erb :stories, locals: { items: items }
    end

    get '/pullrequests' do
      repository = 'powerhome/ninja-seal'
      pr_list = GithubWebhook.open_pull_requests(repository)

      erb :pullrequests, locals: {prs: pr_list, repository: repository}
    end

    run!
  end
end
