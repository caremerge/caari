# Description:
#   Example scripts for @moqada/hubot-schedule-helper
#
# Commands:
#   hubot schedule add "<cron pattern>" <message> - Add Schedule
#   hubot schedule cancel <id> - Cancel Schedule
#   hubot schedule update <id> <message> - Update Schedule
#   hubot schedule list - List Schedule
{Scheduler, Job, JobNotFound, InvalidPattern} = require '@moqada/hubot-schedule-helper'

storeKey = 'hubot-schedule-helper-example:schedule'


class ExampleJob extends Job
  exec: (robot) ->
    robot.send @getEnvelope(), @meta.message



module.exports = (robot) ->
  scheduler = new Scheduler({robot, storeKey, job: ExampleJob})

  robot.respond /schedule add "(.+)" (.+)$/i, (res) ->
    [pattern, message] = res.match.slice(1)
    {user} = res.message
    try
      job = scheduler.createJob({pattern, user, meta: {message}})
      res.send "Created: #{job.id}"
    catch err
      if err.name is InvalidPattern.name
        return res.send 'invalid pattern!!!'
      res.send err.message

  robot.respond /schedule cancel (\d+)$/i, (res) ->
    [id] = res.match.slice(1)
    try
      scheduler.cancelJob id
      res.send "Canceled: #{id}"
    catch err
      if err.name is JobNotFound.name
        return res.send "Job not found: #{id}"
      res.send err

  robot.respond /schedule list$/i, (res) ->
    jobs = []
    for id, job of scheduler.jobs
      jobs.push "#{id}: \"#{job.pattern}\" ##{job.getRoom()} #{job.meta.message}"
    if jobs.length > 0
      return res.send jobs.join '\n'
    res.send 'No jobs'

  robot.respond /schedule update (\d+) (.+)$/i, (res) ->
    [id, message] = res.match.slice(1)
    try
      scheduler.updateJob id, {message}
      res.send "#{id}: Updated"
    catch err
      if err.name is JobNotFound.name
        return res.send "Job not found: #{id}"
      res.send err

#------------------------------------------------------------------------------------------------------------------------

# Description:
#   Which is Better?
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot which <text> (better|worse)[?,] <text> or <text>? #polls
#   hubot who <text> (better|worse)[?,] <text> or <text>? #polls
#
# Author:
#   cpradio


#------------------------------------------------------------------------------------------------------------------------

# robot.hear /badger/i, (res) ->
#   res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"
#
# robot.respond /open the (.*) doors/i, (res) ->
#   doorType = res.match[1]
#   if doorType is "pod bay"
#     res.reply "I'm afraid I can't let you do that."
#   else
#     res.reply "Opening #{doorType} doors"
#
# robot.hear /I like pie/i, (res) ->
#   res.emote "makes a freshly baked pie"
#
# lulz = ['lol', 'rofl', 'lmao']
#
# robot.respond /lulz/i, (res) ->
#   res.send res.random lulz
#
# robot.topic (res) ->
#   res.send "#{res.message.text}? That's a Paddlin'"
#
#
# enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
# leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
#
# robot.enter (res) ->
#   res.send res.random enterReplies
# robot.leave (res) ->
#   res.send res.random leaveReplies
#
# answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
#
# robot.respond /what is the answer to the ultimate question of life/, (res) ->
#   unless answer?
#     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
#     return
#   res.send "#{answer}, but what is the question?"
#
# robot.respond /you are a little slow/, (res) ->
#   setTimeout () ->
#     res.send "Who you calling 'slow'?"
#   , 60 * 1000
#
# annoyIntervalId = null
#
# robot.respond /annoy me/, (res) ->
#   if annoyIntervalId
#     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
#     return
#
#   res.send "Hey, want to hear the most annoying sound in the world?"
#   annoyIntervalId = setInterval () ->
#     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
#   , 1000
#
# robot.respond /unannoy me/, (res) ->
#   if annoyIntervalId
#     res.send "GUYS, GUYS, GUYS!"
#     clearInterval(annoyIntervalId)
#     annoyIntervalId = null
#   else
#     res.send "Not annoying you right now, am I?"
#
#
# robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
#   room   = req.params.room
#   data   = JSON.parse req.body.payload
#   secret = data.secret
#
#   robot.messageRoom room, "I have a secret: #{secret}"
#
#   res.send 'OK'
#
# robot.error (err, res) ->
#   robot.logger.error "DOES NOT COMPUTE"
#
#   if res?
#     res.reply "DOES NOT COMPUTE"
#
# robot.respond /have a soda/i, (res) ->
#   # Get number of sodas had (coerced to a number).
#   sodasHad = robot.brain.get('totalSodas') * 1 or 0
#
#   if sodasHad > 4
#     res.reply "I'm too fizzy.."
#
#   else
#     res.reply 'Sure!'
#
#     robot.brain.set 'totalSodas', sodasHad+1
#
# robot.respond /sleep it off/i, (res) ->
#   robot.brain.set 'totalSodas', 0
#   res.reply 'zzzzz'
