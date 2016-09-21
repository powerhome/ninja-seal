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

    def self.open_pull_requests(repository)
      pull_requests = []
      Octokit.pull_requests(repository, status: 'open').each do |pr|
        statuses = Octokit.combined_status(repository, pr[:head][:sha])[:statuses]
        status = statuses.select{ |st| st[:context] == 'ninja-seal' }

        pull_request = {title: pr[:title], sha: pr[:head][:sha] }
        pull_request.merge({ status: status.state }) if !status.empty?

        pull_requests << pull_request
      end
      pull_requests
    end
  end
end
