require 'spec_helper'

describe NinjaSeal::Github do
  it 'receives posts from github webhook' do
    allow(Octokit).to receive(:create_status)

    params = { pull_request: { head: { repo: { full_name: '' } } } }
    post '/webhook/github', params

    expect(last_response).to be_ok
  end
end
