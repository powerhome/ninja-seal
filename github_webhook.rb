require 'octokit'

Octokit.configure do |c|
  c.login = 'xjunior'
  c.password = '46fbd65e1df9d86301f75f2b66a780194d91e197'
end

module NinjaSeal
  class GithubWebhook < Sinatra::Base
    NINJA_CONTEXT = 'Ninja Seal of Approval'

    post '/webhook/github' do
      options = { context: NINJA_CONTEXT }
      pull_request = params['pull_request']
      head = pull_request['head']
      repository_name = head['repo']['full_name']
      commitish = head['sha']
      Octokit.client.create_status(repository_name, commitish, :pending, options)
      200
    end

    post '/:repo/:sha/status/:status' do
      # Octokit.client.create_statuses(params[:repo], params[:sha], params[:status], { context: NINJA_CONTEXT })
    end
  end
end
