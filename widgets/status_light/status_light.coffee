class Dashing.StatusLight extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered
    @popover = $(@node).find('a').each(
      () ->
        $(this).popover(
          placement: 'auto top',
          trigger: 'hover'
        )
    )

  onData: (data) ->