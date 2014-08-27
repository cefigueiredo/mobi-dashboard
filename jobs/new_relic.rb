require 'json'

servers_raw = File.read('JSON_SERVIDORES.json')
servers = JSON.parse(servers_raw)['servers'].map { |srv| srv}
# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '10s', :first_in => 0 do |job|
  servers = servers.map do |srv|
    if srv['summary']
      srv['summary']['cpu'] = rand
      srv['summary']['memory'] = srv['summary']['memory'] * rand(10)
      srv['summary']['disk_io'] = srv['summary']['disk_io'] * rand(10)
    end
    srv
  end

  send_event('my_widget', { servers: servers })
end