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
      pr_resource = Octokit.pull_requests('powerhome/ninja-seal', status: 'open')
      pr_list = []
      pr_resource.each do |pr|
        statuses = Octokit.combined_status('powerhome/ninja-seal', pr[:head][:sha])[:statuses]
        status = statuses.select do |st|
          st[:context] == 'ninja-seal'
        end

        if !status.empty?
          pr_list << {title: pr[:title], status: status.state, sha: pr[:head][:sha] }
        else
          pr_list << {title: pr[:title], status: 'none', sha: pr[:head][:sha] }
        end
      end
      erb :pullrequests, locals: {prs: pr_list}
    end

    run!
  end
end
