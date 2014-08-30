Batman.Filters.dateFormat = (date, format) ->
  moment(date).format(format) if date?