# Description:
#   Assign youtube channel to user
#
# Commands:
#   hubot channel <user>
#   hubot channel add <user> <channel>
#
# Examples:
#   hubot channel vocino
#   hubot channel add vocino vocino

module.exports = (robot) ->

  if process.env.HUBOT_AUTH_ADMIN?
    robot.logger.warning 'The HUBOT_AUTH_ADMIN environment variable is set not going to load channels.coffee, you should delete it'
    return

  getAmbiguousUserText = (users) ->
    "Be more specific, I know #{users.length} people named like that: #{(user.name for user in users).join(", ")}"

  robot.respond /channel @?([\w .\-]+)\?*$/i, (msg) ->
    joiner = ', '
    name = msg.match[1].trim()

    users = robot.brain.usersForFuzzyName(name)
    if users.length is 1
      user = users[0]
      user.channels = user.channels or [ ]
      if user.channels.length > 0
        if user.channels.join('').search(',') > -1
          joiner = '; '
        msg.send "#{name}'s channel is http://youtube.com/#{user.channels.join(joiner)}"
      else
        msg.send "I don't know #{name}'s channel. Use 'channel add <name> <channel>'"
    else if users.length > 1
      msg.send getAmbiguousUserText users
    else
      msg.send "#{name}? Never heard of 'em"

  robot.respond /channel add @?([\w .\-_]+) (["'\w: \-_]+)[.!]*$/i, (msg) ->
    name    = msg.match[1].trim()
    newChannel = msg.match[2].trim()

    users = robot.brain.usersForFuzzyName(name)
    if users.length is 1
      user = users[0]
      user.channels = user.channels or [ ]

      if newChannel in user.channels
        msg.send "I know"
      else
        user.channels.push(newChannel)
        if name.toLowerCase() is robot.name.toLowerCase()
          msg.send "Ok, my channel is #{newChannel}."
        else
          msg.send "Ok, #{name}'s channel is http://youtube.com/#{newChannel}"
    else if users.length > 1
      msg.send getAmbiguousUserText users
    else
      msg.send "I don't know #{name}'s channel. Use 'channel add <name> <channel>'"

  robot.respond /channel remove @?([\w .\-_]+) (["'\w: \-_]+)[.!]*$/i, (msg) ->
    name    = msg.match[1].trim()
    newChannel = msg.match[2].trim()

    users = robot.brain.usersForFuzzyName(name)
    if users.length is 1
      user = users[0]
      user.channels = user.channels or [ ]

      if newChannel not in user.channels
        msg.send "I know."
      else
        user.channels = (channel for channel in user.channels when channel isnt newChannel)
        msg.send "Ok, #{newChannel} is no longer associated with #{name}"
    else if users.length > 1
      msg.send getAmbiguousUserText users
    else
      msg.send "I don't know #{name}'s channel."

