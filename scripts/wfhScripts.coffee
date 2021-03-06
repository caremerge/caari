# Description:
#   work from home scripts
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   working from home/on leave
#
# Author:
#   Sarah Noor


leaveForm = process.env.LEAVE_FORM
testChannel = process.env.TEST_CHANNEL
cagChannel = process.env.CAG_CHANNEL 


module.exports = (robot) ->

  robot.hear /work from home|working from home|on leave|half leave|work fh|wfh/i, (msg)->
    if msg.message.room == testChannel || msg.message.room == cagChannel
      msg.reply "Please apply for time off through BambooHR " + leaveForm

  robot.respond /leave form|wfh form/i, (msg) ->
    msg.reply leaveForm