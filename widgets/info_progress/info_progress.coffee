class Dashing.InfoProgress extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered
    @chart = $(@node).find('.easy-pie-chart.percentage').each(
      () ->
        $box = $(this).closest('.infobox')
        barColor = $(this).data('color') || 'rgba(0, 0, 253, 0.7)'
        trackColor = 'rgba(49, 168, 253, 0.3)'
        size = parseInt($(this).data('size')) || 40

        $(this).easyPieChart(
          barColor: barColor,
          trackColor: trackColor,
          scaleColor: false,
          lineCap: 'butt',
          lineWidth: parseInt(size/10),
          animate: /msie\s*(8|7|6)/.test(navigator.userAgent.toLowerCase()) ? false : 1000,
          size: size
        )
    )

    # `$(@node).find('.easy-pie-chart.percentage').each(function(){
    #   var $box = $(@node).closest('.infobox');
    #   var barColor = $(this).data('color') || (!$box.hasClass('infobox-dark') ? $box.css('color') : 'rgba(255,255,255,0.95)');
    #   var trackColor = barColor == 'rgba(255,255,255,0.95)' ? 'rgba(255,255,255,0.25)' : '#E2E2E2';
    #   var size = parseInt($(this).data('size')) || 50;
    #   $(this).easyPieChart({
    #     barColor: barColor,
    #     trackColor: trackColor,
    #     scaleColor: false,
    #     lineCap: 'butt',
    #     lineWidth: parseInt(size/10),
    #     animate: /msie\s*(8|7|6)/.test(navigator.userAgent.toLowerCase()) ? false : 1000,
    #     size: size
    #   });
    # });`
  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
    @chart.update(data)





