assert = require 'assert'
mapmongo = require '../lib';

init = (options, callback) ->
  mapmongo.config {
    name   : 'map-mongo-dev'
    host   : '127.0.0.1'
    port   : 27017
    user   : ''
    passwd : ''
  }

  callback()

afterEach = (callback) ->
  mapmongo.conn.disconnect ->
    callback()

testAvailability = (callback) ->

  mapmongo.colls 'foo', (error, coll) ->
    return callback error if error

    assert.equal coll.collectionName, 'foo'

    callback()

module.exports =
  afterEach        : afterEach
  init             : init
  testAvailability : testAvailability
