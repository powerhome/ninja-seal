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

    set :views, 'views'

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
