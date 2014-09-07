class Server extends Batman.Object

  @accessor 'status', ->
    new Batman.TerminalAccessible (subject) =>
      if @get('reporting')
        subject_value = @get('summary')[subject]
        policy = _.chain(@get('policies'))
          .filter((policy) -> policy.type == subject )
          .sortBy((policy) -> -policy.threshold)
          .find((limit) -> subject_value >= limit.threshold)
          .value()

        if _(policy).isUndefined()
          'ok'
        else
          policy.severity


class Dashing.ServerList extends Dashing.Widget
  @accessor 'servers', ->
    servers = @get('servers_data')
    serverSet = new Batman.Set()
    all_policies = @get('alert_policies')

    _(servers).forEach(
      (srv) ->
        policies = _(all_policies).filter((pol) -> pol.account_id == srv.account_id)
        serverSet.add(new Server(srv, {policies: policies})))
    _(serverSet.toArray()).sortBy((x) -> -x.reporting)


  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    @policiesHash_ = _.groupBy @get('policies'), (pol) -> pol.type

    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.