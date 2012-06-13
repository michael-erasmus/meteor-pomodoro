twentyFiveMinutes  = 25 * 60 * 1000 # 25 minutes
defaultPomodoroTime = twentyFiveMinutes
fiveMinutes = 5 * 60 * 1000

Pomodoros = new Meteor.Collection('pomodoros')

yesterday = new Date()
yesterday.setDate(yesterday.getDate() - 1)
yesterday.setHours(0,0,0,0)

breakPomodoro = (id) ->
  Pomodoros.update(id, $set:{time_ended: new Date()})

if Meteor.is_client
  Template.notify.message = -> Session.get("notify")

  createPomodoro = (name,time=defaultPomodoroTime)->
    Pomodoros.insert({
        name: name,
        time_started: new Date()
      },(e,id) ->
      Meteor.setTimeout ->
        finishPomodoro(id)
        $('#tick')[0].pause()
        $('#ring')[0].play()
      ,time
    )
    $('#new_entry_name').val('')
    $('#tick')[0].play()
    $('#notifyModal').modal('show')

  finishPomodoro = (id) ->
    Pomodoros.update(id, $set:{time_ended: new Date()})
    $('#notifyModal').modal('hide')


  Template.today.all = ->
    Pomodoros.find
      time_started:
        $gt: yesterday
      {sort: time_started: -1}
     
  Template.before.all = ->
    Pomodoros.find
      time_started:
        $lte: yesterday
      {sort: time_started: -1}

  Template.today.events =
    'submit #new_entry': (event) ->
      event.preventDefault()
      Session.set('notify', 'Focus')
      createPomodoro($('#new_entry_name').val())


    'click .break': (event) ->
      breakPomodoro event.toElement.dataset.id
      $('#tick')[0].pause()
      $('#ring')[0].play()
    
    'click #break-5': (event) ->
      Session.set('notify', 'Relax')
      createPomodoro "5 minute break", fiveMinutes
      
    'click #break-25': (event) ->
      Session.set('notify', 'Relax')
      createPomodoro "5 minute break", twentyFiveMinutes
