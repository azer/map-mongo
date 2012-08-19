assert   = require 'assert'
each     = require('functools').each.async
mapmongo = require '../lib'

people = mapmongo 'people', {
    name : String
    age  : Number
  }

init = (options, callback) ->
  mapmongo.config {
    name   : 'map-mongo-dev'
    host   : '127.0.0.1'
    port   : 27017
    user   : ''
    passwd : ''
  }

  callback()

end = (callback) ->
  mapmongo.conn.disconnect ->
    callback()

testSaveFindRemove = (callback) ->
  azer = people {
    name: 'azer'
    age: 25
  }

  bob = people {
    name: 'bob'
    age: 20
  }

  kath = people {
    name: 'kath'
    age: 20
  }

  each people.save, [azer, bob, kath], (error) ->
    return callback error if error

    people.find { age: 20 }, (error, result) ->
      return callback error if error

      assert.ok result.length >= 2
      assert.equal result[0].name(), 'bob'
      assert.equal result[1].name(), 'kath'

      people.find (error, result) ->
        return callback error if error

        assert.ok result.length >= 3

        people.remove (error, result) ->
          return callback error if error

          people.find (error, result) ->
            return callback error if error

            assert.equal result.length, 0

            callback()

testSaveGetRemove = (callback) ->
  joe = people {
    name: 'Joe'
    age: 20
  }

  people.save joe, (error) ->
    return callback error if error

    assert.ok joe.id()
    assert.equal joe.name(), 'Joe'
    assert.equal joe.age(), 20

    joe.age 21

    people.save joe, (error) ->
      return callback error if error

      people.get joe.id(), (error, copy) ->
        return callback error if error

        assert.notEqual joe, copy
        assert.equal joe.id(), copy.id()
        assert.equal joe.name(), copy.name()
        assert.equal joe.age(), copy.age()

        people.remove joe, (error) ->
          return callback error if error

          assert.equal joe.id(), undefined

          people.get joe.id(), (error, copy) ->
            return callback error if error

            assert.equal copy, undefined

            callback()

module.exports =
  init               : init
  end                : end
  testSaveFindRemove : testSaveFindRemove
  testSaveGetRemove  : testSaveGetRemove
