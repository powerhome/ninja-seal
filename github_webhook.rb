require 'sinatra/base'
require 'octokit'
require 'json'
require 'byebug'

Octokit.configure do |c|
  c.login = 'xjunior'
  c.password = '068b87783ebf7b9bafdf1d6d42c06c5385ad13e7'
end

module NinjaSeal
  class GithubWebhook < Sinatra::Base
    post '/webhook/github' do
      data = { context: "Ninja Seal of Approval" }
      pull_request = params['pull_request']
      head = pull_request['head']
      Octokit.client.create_status(head['repo']['full_name'], head['sha'], :pending, data)
    end

    post '/:repo/:sha/status/:status' do
      Octokit.client.create_statuses(params[:repo], params[:sha], params[:status], { context: "Ninja Seal of Approval" })
    end
  end
end
