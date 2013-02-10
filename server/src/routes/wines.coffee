# coffee -w -o server/target -c server/src/

mongo = require 'mongodb'
mongoServer = mongo.Server
mongoDatabase = mongo.Db
BSON = mongo.BSONPure

# ------------------------------ #

connectToMongoServer = new mongoServer 'localhost', 27017, auto_reconnect:true
wineDataBase = new mongoDatabase 'winedb', connectToMongoServer

wineDataBase.open (err, wineDataBase) ->
  if not err
    console.log "Connected to 'winedb' database"
    wineDataBase.collection 'wines', safe:true, (err, collection) ->
      if err
        console.log "The 'wines' collection doesn't exist. Creating it with sample data..."
        populateDB()

# ------------------------------ #

exports.findById = (req, res) ->
  id = req.params.id
  console.log 'Retrieving wine: ' + id
  wineDataBase.collection 'wines', (err, collection) ->
    collection.findOne '_id': new BSON.ObjectID(id), (err, item) ->
      res.send item

exports.findAll = (req, res) ->
  wineDataBase.collection 'wines', (err, collection) ->
    collection.find().toArray (err, items) ->
      res.send items

exports.addWine = (req, res) ->
  wine = req.body
  console.log 'Adding wine: ' + JSON.stringify wine
  wineDataBase.collection 'wines', (err, collection) ->
    collection.insert wine, safe:true, (err, result) ->
      if err
        res.send 'error': 'An error has occured'
      else
        console.log 'Success: ' + JSON.stringify result[0]
        res.send result[0]

exports.updateWine = (req, res) ->
  id = req.params.id
  wine = req.body
  console.log 'Updating wine: ' + id
  console.log JSON.stringify wine
  wineDataBase.collection 'wines', (err, collection) ->
    collection.update '_id':new BSON.ObjectID(id), wine, safe:true, (err, result) ->
      if err
        console.log 'Error updating wine: ' + err
        res.send 'error': 'An error has occured'
      else
        console.log '' + result + ' dociment(s) updated'
        res.send(wine)

exports.deleteWine = (req, res) ->
  id = req.params.id
  console.log 'Deleting wine: ' + id
  wineDataBase.collection 'wine', (err, collection) ->
    collection.remove '_id': new BSON.ObjectID(id), safe:true, (err, result) ->
      if err
        res.send 'error':'An error has occurred - ' + err
      else
        console.log '' + result + ' document(s) deleted'
        req.send req.body

populateWineDatabase = ->
  wines = [
    name: "CHATEAU DE SAINT COSME"
    year: "2009"
    grapes: "Grenache / Syrah"
    country: "France"
    region: "Southern Rhone"
    description: "The aromas of fruit and spice..."
    picture: "saint_cosme.jpg"
  ,
    name: "LAN RIOJA CRIANZA"
    year: "2006"
    grapes: "Tempranillo"
    country: "Spain"
    region: "Rioja"
    description: "A resurgence of interest in boutique vineyards..."
    picture: "lan_rioja.jpg"
  ]

  wineDataBase.collection 'wines', (err, collection) ->
    collection.insert wines, safe:true, (err, result) ->