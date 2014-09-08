require 'json'
require 'rest-client'
require 'date'

@accounts = Account.all
@account_status = {}
@alert_policies = []

def servers_check
  @accounts.map do |account|
    result = JSON.parse resource(account, 'servers')
    result['servers']
  end
end

def alert_policies
  @alert_policies = @accounts.map do |account|
    result = JSON.parse resource(account, 'alert_policies', 'filter[enabled]' => true, 'filter[type]' => 'server')
    result['alert_policies'].map do |pol_group|
      pol_group['conditions'].map {|policy| policy.merge({'account_id' => account.id})}
    end
  end.flatten
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
  alert_policies if @alert_policies.empty?
  send_event('my_widget', { servers_data: servers, alert_policies: @alert_policies, status_accounts: @account_status })

  ActiveRecord::Base.connection.close
end

SCHEDULER.every '1h', :first_in => 0 do |job|
  @accounts = Account.all
  @alert_policies = alert_policies

  ActiveRecord::Base.connection.close
end
