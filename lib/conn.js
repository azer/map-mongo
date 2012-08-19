var memoize = require('functools').memoize.async,
    mongodb = require('mongodb'),
    debug   = require('debug')('conn'),
    config  = require('./config');

var id, client;

function connect(callback){
  var options = config();

  debug('Connecting to mongodb://%s:%d. ID: %s', options.host, options.port, id);

  var server    = new mongodb.Server(options.host, options.port, options.serverOptions),
      connector = new mongodb.Db(options.name, server, options.options);

  module.exports.lastConnectionTS = +(new Date);

  connector.open(function(error, newClient){
    if(error){
      callback(error);
      return;
    }

    client = newClient;
    callback(undefined, client);
  });
}

function disconnect(callback){
  debug('Disconnecting %s', id);

  client && client.close(function(error){
    if(error){
      callback(error);
      return;
    }

    reset();
    callback();
  });
}

function reset(){
  id = '#' + +(new Date);
}

module.exports = memoize(connect, function(){
  client && client.state == 'disconnected' && reset();
  return id;
});

module.exports.disconnect = disconnect;
