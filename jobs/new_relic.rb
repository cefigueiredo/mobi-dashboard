require 'json'
require 'rest-client'
require 'pry'
require 'date'


def servers_check
  resource = RestClient::Resource.new('https://api.newrelic.com/v2')
  Account.all.map do |account|
    result = resource['servers.json'].get('X-Api-Key' => account.api_key)
    check = AccountCheck.create( :account => account,
                         :status  => result.headers[:status],
                         :date    => Time.parse(result.headers[:date]).getlocal('-03:00'))
    JSON.parse(result)['servers'].map do |srv|
      srv.merge({ 'check' => check.attributes })
    end
  end
end
# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  servers = servers_check.flatten
  send_event('my_widget', { servers: servers })
end
