require 'json'
require 'rest-client'
require 'date'

@accounts = Account.all

def servers_check
  @accounts.map do |account|
    result = JSON.parse resource(account, 'servers')
    result['servers']
  end
end

def resource(account, subject, params = {})
  api = RestClient::Resource.new('https://api.newrelic.com/v2')
  api["#{subject}.json"].get('X-Api-Key' => account.api_key, :params => params).tap do |result|
    @account_status[account.id] = AccountCheck.create(
      :account => account,
      :status  => result.headers[:status],
      :date    => Time.parse(result.headers[:date]).getlocal('-03:00')
    )
  end
end

SCHEDULER.every '1m', :first_in => 0 do |job|
  send_event('my_widget', { servers: servers_check.flatten })
  ActiveRecord::Base.connection.close
end
