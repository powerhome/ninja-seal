require 'octokit'

Octokit.configure do |c|
  c.login = ENV['GITHUB_LOGIN']
  c.password = ENV['GITHUB_KEY']
end

module NinjaSeal
  class GithubWebhook < Sinatra::Base
    NINJA_CONTEXT = 'Ninja Seal of Approval'.freeze

    post '/webhook/github' do
      options = { context: NINJA_CONTEXT }
      pull_request = params['pull_request']
      head = pull_request['head']
      repository_name = head['repo']['full_name']
      commitish = head['sha']
      Octokit.client.create_status(repository_name, commitish, :pending, options)
      200
    end

    post '/:org/:repo/:sha/status' do
      repository = "#{params[:org]}/#{params[:repo]}"
      Octokit.client.create_status(repository, params[:sha], params[:status], {
        context: NINJA_CONTEXT
      })
      200
    end
  end
end
