var debug = require('debug')('coll'),
    conn  = require('./conn');

function colls(name, callback){
  debug('Accessing collection "%s"', name);

  conn(function(error, client){

    if(error){
      callback(error);
      return;
    }

    client.collection(name, callback);
  });

}

module.exports = colls;
