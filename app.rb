require 'sinatra'
require 'json'
require 'byebug'
require 'rack/parser'
require 'dotenv'
require './github_webhook'
require 'pry'
require './github'

module NinjaSeal
  class App < Sinatra::Base
    use Rack::Parser, parsers: {
      'application/json' => -> (data) { JSON.parse(data) }
    }

    set :views, 'views'

    get '/pullrequests' do
      pr_resource = Octokit.pull_requests('powerhome/nitro-web', status: 'open')
      pr_list = []
      pr_resource.each do |pr|
        statuses = Octokit.combined_status('powerhome/nitro-web', pr[:head][:sha])[:statuses]
        status = statuses.select do |st|
          st[:context] == 'ninja-seal'
        end

        if !status.empty?
          pr_list << {title: pr[:title], status: status.state }
        else
          pr_list << {title: pr[:title], status: 'none' }
        end
      end
      erb :pullrequests, locals: {prs: pr_list}
    end

    run!
  end
end
