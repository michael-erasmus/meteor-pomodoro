Handlebars.registerHelper 'date', (date) -> 
  if date 
    dateObj = new Date(date)
    $.timeago(dateObj)
  else 
    'a long long time ago in a galaxy far away'

