# Licensed under the Apache License. See footer for details.

# use this file with jbuild: https://www.npmjs.org/package/jbuild

fs   = require "fs"
path = require "path"

#-------------------------------------------------------------------------------
tasks = defineTasks exports,
    watch :   "watch for source file changes, then run build and tests"
    build :   "build the program"
    test:     "run tests"
    serve:    "run the test server stand-alone"

WatchSpec = "lib-src/**/* tests/**/*"

#-------------------------------------------------------------------------------
mkdir "-p", "tmp"

#-------------------------------------------------------------------------------
tasks.build = ->
    cleanDir "lib"

    log "starting build"

    log "compiling CoffeeScript"
    coffee "--output lib lib-src"

#-------------------------------------------------------------------------------
tasks.watch = ->
    buildNserve()

    watch
        files: WatchSpec.split " "
        run:   buildNserve

    watchFiles "jbuild.coffee" :->
        log "jbuild file changed; exiting"
        process.exit 0

#-------------------------------------------------------------------------------
tasks.serve = ->
    command = "server"
    server.start "tmp/server.pid", "node", command.split " "

#-------------------------------------------------------------------------------
tasks.test = ->
    tests = "tests/test-*.coffee"

    options =
        ui:         "bdd"
        reporter:   "spec"
        slow:       300
        compilers:  "coffee:coffee-script"
        require:    "coffee-script/register"

    options = for key, val of options
        "--#{key} #{val}"

    options = options.join " "

    log "starting tests"
    mocha "#{options} #{tests}"

#-------------------------------------------------------------------------------
buildNtest = ->
    tasks.build()
    tasks.test()

#-------------------------------------------------------------------------------
buildNserve = ->
    tasks.build()
    tasks.serve()

#-------------------------------------------------------------------------------
cleanDir = (dir) ->
    mkdir "-p", dir
    rm "-rf", "#{dir}/*"

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
