# Description:
#   Allows you to chat with hubot as a proxy to cleverbot
#
# Dependencies:
#   None
#
#   Includes code from cleverbot-node (https://github.com/fojas/cleverbot-node)
#
# Configuration:
#   None
#
# Commands:
#   hubot chat <dialog>  - returns cleverbot's response to your dialog
#
# Author:
#   Bob Williams - https://github.com/bobwilliams

crypto = require("crypto")
http = require("http")
Cleverbot = ->
  @params = Cleverbot.default_params

Cleverbot.default_params =
  stimulus: ""
  start: "y"
  sessionid: ""
  vText8: ""
  vText7: ""
  vText6: ""
  vText5: ""
  vText4: ""
  vText3: ""
  vText2: ""
  icognoid: "wsf"
  icognocheck: ""
  fno: "0"
  prevref: ""
  emotionaloutput: ""
  emotionalhistory: ""
  asbotname: ""
  ttsvoice: ""
  typing: ""
  lineref: ""
  sub: "Say"
  islearning: "1"
  cleanslate: "false"

Cleverbot.parserKeys = ["message", "sessionid", "logurl", "vText8", "vText7", "vText6", "vText5", "vText4", "vText3", "vText2", "prevref", "", "emotionalhistory", "ttsLocMP3", "ttsLocTXT", "ttsLocTXT3", "ttsText", "lineref", "lineURL", "linePOST", "lineChoices", "lineChoicesAbbrev", "typingData", "divert"]
Cleverbot.digest = (body) ->
  m = crypto.createHash("md5")
  m.update body
  m.digest "hex"

Cleverbot.encodeParams = (a1) ->
  u = []
  for x of a1
    if a1[x] instanceof Array
      u.push x + "=" + encodeURIComponent(a1[x].join(","))
    else if a1[x] instanceof Object
      u.push params(a1[x])
    else
      u.push x + "=" + encodeURIComponent(a1[x])
  u.join "&"

Cleverbot:: = write: (message, callback) ->
  clever = this
  body = @params
  body.stimulus = message
  body.icognocheck = Cleverbot.digest(Cleverbot.encodeParams(body).substring(9, 29))
  options =
    host: "www.cleverbot.com"
    port: 80
    path: "/webservicemin"
    method: "POST"
    headers:
      "Content-Type": "application/x-www-form-urlencoded"
      "Content-Length": Cleverbot.encodeParams(body).length

  req = http.request(options, (res) ->
    cb = callback or ->

    res.on "data", (chunk) ->
      chunk_data = chunk.toString().split("\r")
      responseHash = {}
      i = 0
      iLen = chunk_data.length

      while i < iLen
        clever.params[Cleverbot.parserKeys[i]] = responseHash[Cleverbot.parserKeys[i]] = chunk_data[i]
        i++
      cb responseHash

  )
  req.write Cleverbot.encodeParams(body)
  req.end()


#module.exports = Cleverbot;
module.exports = (robot) ->
  robot.respond /chat (.*)/i, (msg) ->
    cleverbot = new Cleverbot()
    cleverbot.write msg.match[1], (answer) ->
      msg.send answer["message"]

