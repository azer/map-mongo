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
  mapmongo.conn (error, client) ->
    return callback error if error

    assert.equal client.state, 'connected'

    mapmongo.conn.disconnect (error) ->
      return callback error if error
      callback()

testMemoization = (callback) ->
  mapmongo.conn (error, client) ->
    return callback error if error

    connectedAt = mapmongo.conn.lastConnectionTS

    mapmongo.conn (error, client) ->
      return callback error if error

      assert.equal mapmongo.conn.lastConnectionTS, connectedAt;

      client.close ->
        return callback error if error

        mapmongo.conn (error, client) ->
          return callback error if error

          assert.notEqual mapmongo.conn.lastConnectionTS, connectedAt;
          assert.equal client.state, 'connected'

          callback()

module.exports =
  afterEach        : afterEach
  init             : init
  testAvailability : testAvailability
  testMemoization  : testMemoization
