# Description:
#   Assign youtube channel to user
#
# Commands:
#   hubot channel <user>
#   hubot channeladd <user> <channel>
#   hubot channelremove <user> <channel>
#
# Examples:
#   hubot channel vocino
#   hubot channeladd vocino vocino

module.exports = (robot) ->

  if process.env.HUBOT_AUTH_ADMIN?
    robot.logger.warning 'The HUBOT_AUTH_ADMIN environment variable is set not going to load channels.coffee, you should delete it'
    return

  getAmbiguousUserText = (users) ->
    "Be more specific, I know #{users.length} people named like that: #{(user.name for user in users).join(", ")}"

  robot.respond /channel @?([\w .\-]+)\?*$/i, (msg) ->
    name = msg.match[1].trim()

    users = robot.brain.usersForFuzzyName(name)
    if users.length is 1
      user = users[0]
      user.channels = user.channels or [ ]
      if user.channels.length = 1
        msg.send "#{name}'s channel is http://youtube.com/#{user.channels}"
      else if user.channels.length > 1
        joiner = ' http://youtube.com/'
        msg.send "#{name}'s channels are:#{user.channels.join(joiner)}"
      else
        msg.send "I don't know #{name}'s channel. Use 'channeladd <name> <channel_username>' (not the url)"
    else if users.length > 1
      msg.send getAmbiguousUserText users

  robot.respond /channeladd @?([\w .\-_]+) (["'\w: \-_]+)[.!]*$/i, (msg) ->
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
      msg.send "I don't know #{name}'s channel. Use 'channeladd <name> <channel_username>' (not the url)"

  robot.respond /channelremove @?([\w .\-_]+) (["'\w: \-_]+)[.!]*$/i, (msg) ->
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
        msg.send "Ok, http://youtube.com/#{newChannel} is no longer associated with #{name}"
    else if users.length > 1
      msg.send getAmbiguousUserText users
    else
      msg.send "I don't know #{name}'s channel."

  robot.hear /./i, (msg) ->
    return unless robot.brain.user.channels?
    if (allChannels = robot.brain.user.channels[user.name])
      randomChannel = allChannels[Math.floor(Math.random() * allChannels.length)]

      if Math.floor(Math.random() * 100) == 42
        msg.send "Check out what's new on #{user.name}'s channel at http://youtube.com/#{user.channels}"

