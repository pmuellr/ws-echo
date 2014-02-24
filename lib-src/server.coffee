# Licensed under the Apache License. See footer for details.

http = require "http"

express      = require "express"
websocket    = require "websocket"

WebSocketServer = websocket.server

pkg = require "../package.json"

#-------------------------------------------------------------------------------
exports.main = ->
    logError "PORT environment variable not set" unless process.env.PORT?

    port = parseInt process.env.PORT
    logError "invalid PORT environment variable: #{process.env.PORT}" if isNaN port

    app = express()
    # app.use CORSify
    app.use express.static "www"

    server = http.createServer app

    server.listen port, ->
        log "server started: http://localhost:#{port}"

    wsServer = new WebSocketServer
        httpServer: server

    wsServer.on "request", (request) -> on_request(request)

#-------------------------------------------------------------------------------
on_request = (request) ->
    log "connection from origin: #{request.origin}"

    connection = request.accept(null, request.origin)

    connection.on "message", (message) ->
        if  message.type is "utf8"
            log "received message: #{message.utf8Data}"
            connection.sendUTF message.utf8Data

        else if message.type is "binary"
            log "received binary message of #{message.binaryData.length} bytes"
            connection.sendBytes message.binaryData

    connection.on "close", (reasonCode, description) ->
        log "peer #{connection.remoteAddress} disconnected."

#-------------------------------------------------------------------------------
log = (message) ->
    console.log "#{pkg.name}: #{message}"

#-------------------------------------------------------------------------------
logError = (message) ->
    log message
    process.exit 1

#-------------------------------------------------------------------------------
# add CORS headers to response
#-------------------------------------------------------------------------------
CORSify = (request, response, next) ->
    response.header "Access-Control-Allow-Origin:", "*"
    response.header "Access-Control-Allow-Methods", "POST, GET,"
    next()

#-------------------------------------------------------------------------------
# Copyright 2014 Patrick Mueller
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------------
