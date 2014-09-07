class Dashing.StatusLight extends Dashing.Widget
  constructor: ->
    super
    @accessor 'icon', ->
      status = @context.get(@get('contextStatus'))
      switch status
        when 'ok' then 'icon-ok-sign'
        when 'caution' then 'icon-warning-sign'
        when 'critical' then 'icon-exclamation-sign'
        else 'icon-remove-sign'

  ready: ->
    # This is fired when the widget is done being rendered
    @popover = $(@node).find('a').each(
      () ->
        $(this).popover(
          placement: 'auto top',
          trigger: 'hover'
        )
    )

