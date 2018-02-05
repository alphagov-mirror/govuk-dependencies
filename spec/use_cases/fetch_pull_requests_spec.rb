describe UseCases::FetchPullRequests do
  it 'Calls execute on the gateway' do
    pull_request_gateway = double(execute: [])
    result = described_class.new(gateway: pull_request_gateway).execute
    expect(result).to eq([])
  end

  it 'Formats summarised pull requests' do
    pull_request_gateway = double(execute: [])
    result = described_class.new(gateway: pull_request_gateway).execute
    expect(result).to eq([])
  end

  context 'Given one pull request' do
    it 'returns a single formtted result' do
      pull_request_gateway = double(execute: [
        Domain::PullRequest.new(
          application_name: 'frontend',
          title: 'Bump Rails from 4.2 to 5.0',
          opened_at: Date.today,
          url: 'https://github.com/alphagov/frontend/pulls/123'
        )
      ])

      result = described_class.new(gateway: pull_request_gateway).execute

      expect(result).to eq([{
        application_name: 'frontend',
        title: 'Bump Rails from 4.2 to 5.0',
        url: 'https://github.com/alphagov/frontend/pulls/123',
        open_since: 'today'
      }])
    end

    context 'Given multiple pull requests' do
      it 'returns a list of formatted results' do
        pull_request_gateway = double(execute: [
          Domain::PullRequest.new(
            application_name: 'frontend',
            title: 'Bump Rails from 4.2 to 5.0',
            opened_at: Date.today,
            url: 'https://github.com/alphagov/frontend/pulls/123'
          ),
          Domain::PullRequest.new(
            application_name: 'publisher',
            title: 'Bump Rails from 3.2 to 4.0',
            opened_at: Date.today,
            url: 'https://github.com/alphagov/publisher/pulls/123'
          )
        ])

        result = described_class.new(gateway: pull_request_gateway).execute

        expect(result).to eq([
          {
            application_name: 'frontend',
            title: 'Bump Rails from 4.2 to 5.0',
            url: 'https://github.com/alphagov/frontend/pulls/123',
            open_since: 'today'
          }, {
            application_name: 'publisher',
            title: 'Bump Rails from 3.2 to 4.0',
            url: 'https://github.com/alphagov/publisher/pulls/123',
            open_since: 'today'
          },
        ])
      end
    end
  end
end
