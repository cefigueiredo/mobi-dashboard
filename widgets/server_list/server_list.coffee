class Dashing.ServerList extends Dashing.Widget
  @accessor 'servers', ->
    servers = @get('servers_data')

    _(servers).sortBy((x) -> -x.reporting)


  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    @policiesHash_ = _.groupBy @get('policies'), (pol) -> pol.type

    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.