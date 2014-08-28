require 'json'
require 'rest-client'
require 'pry'


def servers_check
  resource = RestClient::Resource.new('https://api.newrelic.com/v2')
  Account.all.map do |account|
    result = resource['servers.json'].get('X-Api-Key' => account.api_key)
    AccountCheck.create( :account => account,
                         :status  => result.headers[:status],
                         :date    => DateTime.parse(result.headers[:date]))
    JSON.parse(result)['servers'] || []
  end
end
# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  servers = servers_check.flatten
  send_event('my_widget', { servers: servers })
end
