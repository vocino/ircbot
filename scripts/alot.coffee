# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Author:
#   tbwIII

images = [
  "http://i.imgur.com/RvWwQom.jpg",
  "http://i.imgur.com/YWyuE7K.png",
  "http://i.imgur.com/BdoRLoV.png",
  "http://i.imgur.com/lwUQjLq.png"
]

module.exports = (robot) ->
  robot.hear /(^|\W)alot(\z|\W|$)/i, (msg) ->
    msg.send msg.random images
