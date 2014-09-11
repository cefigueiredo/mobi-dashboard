class Dashing.ServerList extends Dashing.Widget
  @accessor 'servers', ->
    servers = @get('servers_data')

    _(servers).sortBy((x) ->
      return 99999 unless x.reporting
      metrics = []
      Batman.forEach(x.status, (key, val) -> metrics.push(val))
      _(metrics).reduce((memo, status) ->
        memo + switch status
          when 'critical' then 1
          when 'caution' then 2
          when 'ok' then 4
      , 0)
    )

  @accessor 'accounts', ->
    @get('status_accounts')

  @accessor 'lastRequest', ->
    status = _.max(@get('status_accounts'), (x) -> moment(x.date))
    moment(status.date)

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->

    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.