// Licensed under the Apache License. See footer for details.


send10("wss://" + window.location.host)
send10( "ws://" + window.location.host)

//------------------------------------------------------------------------------
function send10(wsurl) {
    console.log("connect: " + wsurl)

    var ws = new WebSocket(wsurl)

    ws.onopen = function(event) {
        console.log("open:    " + wsurl)
        looper(wsurl, ws, 10)
    }

    ws.onmessage = function (event) {
        console.log("message: " + wsurl + ": " + event.data)
    }

    ws.onerror = function (error) {
        console.log("error:   " + wsurl + ": " + error)
    }

    ws.onclose = function (event) {
        console.log("close:   " + wsurl + ": " + event)
    }
}

//------------------------------------------------------------------------------
function looper(wsurl, ws, times) {
    var interval = setInterval(oneLoop, 1000)

    function oneLoop() {
        var message = new Date() + " message on " + wsurl
        console.log("send:    " + wsurl + ": " + message)
        ws.send(message)

        times--
        if (times <= 0) clearInterval(interval)
    }

    return interval
}

//------------------------------------------------------------------------------
// Copyright 2014 Patrick Mueller
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//------------------------------------------------------------------------------
