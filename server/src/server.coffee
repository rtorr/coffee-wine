express = require 'express'
routes = require './routes'
wines = require './routes/wines'
http = require 'http'
path = require 'path'

server = express()

# ------------------------------ #

server.configure ->
  server.set 'port', process.env.PORT or 3000
  server.set 'views', __dirname + '/views'
  server.set 'view engine', 'jade'
  server.use express.favicon()
  server.use express.logger('dev')
  server.use express.bodyParser()
  server.use express.methodOverride()
  server.use express.cookieParser('seeecrets string')
  server.use express.session()
  server.use server.router
  server.use express.static path.join __dirname, 'public'

server.configure 'development', ->
  server.use express.errorHandler()

# ------------------------------ #

server.get '/', routes.index
server.get '/wines', wines.findAll
server.post '/wines', wines.addWine
server.get '/wines/:id', wines.findById
server.put '/wines/:id', wines.updateWine
server.delete '/wines/:id', wines.deleteWine


# ------------------------------ #

http.createServer(server).listen server.get('port'), ->
  console.log 'express server on port' + server.get 'port'
