require 'sinatra'
require 'json'
require 'byebug'
require 'rack/parser'
require 'dotenv'
require 'tracker_api'
require 'erubis'
require './github'

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
      repository = 'powerhome/ninja-seal'
      stories = []
      pr_list = Github.open_pull_requests(repository)
      tracker.projects.each do |project|
        project.stories(with_state: :finished).each do |story|
          pr = pr_list.find { |pr| pr[:title].include?(story.id.to_s) }
          if pr
            stories << { id: story.id, title: story.name, state: story.current_state, pr: pr }
          end
        end
      end
      erb :stories, locals: { stories: stories, repository: repository }
    end

    get '/pullrequests' do
      repository = 'powerhome/ninja-seal'

      erb :pullrequests, locals: {prs: pr_list, repository: repository}
    end

    run!
  end
end
