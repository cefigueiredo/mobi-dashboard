require 'json'
require 'rest-client'
require 'date'

@accounts = Account.all
@account_status = {}

def servers_check
  @accounts.map do |account|
    result = JSON.parse resource(account, 'servers')
    alert_policies = alert_policies(account)
    result['servers'].map do |server|
      serialize_server(account, server, alert_policies)
    end
  end
end

def alert_policies(account)
  result = JSON.parse resource(account, 'alert_policies', 'filter[enabled]' => true, 'filter[type]' => 'server')
  result['alert_policies'].map do |pol_group|
    pol_group['conditions']
  end.flatten
end

def serialize_server(account, server, policies)
  server = server.merge({'status' => {'memory' => nil, 'cpu' => nil, 'fullest_disk' => nil}, 'account_name' => account.name})
  unless server['reporting']
    return server
  end

  policies = policies.group_by { |pol| pol['type'] }
  ['memory', 'cpu', 'fullest_disk'].each do |metric|
    status = policies[metric].sort_by{|pol| -pol['threshold'] }.find{ |pol| pol['threshold'] <= server['summary'][metric]}
    status = status ? status['severity'] : 'ok'
    server['status']["#{metric}"] = status
  end
  server
end

def resource(account, subject, params = {})
  api = RestClient::Resource.new('https://api.newrelic.com/v2')
  api["#{subject}.json"].get('X-Api-Key' => account.api_key, :params => params).tap do |result|
    @account_status[account.id] = AccountCheck.create(
      :account => account,
      :status  => result.headers[:status],
      :date    => Time.parse(result.headers[:date]).getlocal('-03:00')
    ).attributes.merge(account_name: account.name)
  end
end

SCHEDULER.every '1m', :first_in => 0 do |job|
  servers = servers_check.flatten
  send_event('my_widget', { servers_data: servers, status_accounts: @account_status.values })

  ActiveRecord::Base.connection.close
end
