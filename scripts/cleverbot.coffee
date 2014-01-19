# Description:
#   "Makes your Hubot even more Clever™"
#
# Dependencies:
#   "cleverbot-node": "0.1.1"
#
# Configuration:
#   None
#
# Commands:
#   letsplay: <input>
#
# Author:
#   ajacksified

cleverbot = require('cleverbot-node')

module.exports = (robot) ->
  c = new cleverbot()

  robot.hear /c (.*)/i, (msg) ->
    data = msg.match[1].trim()
    c.write(data, (c) => msg.send(c.message))

