var mongodb = require('mongodb'),
    map     = require('map'),

    config  = require('./config'),
    conn    = require('./conn'),
    colls   = require('./colls');

module.exports = map({
  'id'       : '_id',
  'get'      : get,
  'find'     : find,
  'remove'   : remove,
  'save'     : save,
  'toString' : toString
});

module.exports.config = config;
module.exports.colls  = colls;
module.exports.conn   = conn;

function get(collName, rawQuery, callback){
  var query = fixQuery(rawQuery) || {};

  colls(collName, function(error, coll){
    if(error){
      callback(error);
      return;
    }

    coll.findOne(query, function(error, doc){

      if(error){
        callback(error);
        return;
      }

      if(!doc){
        callback();
        return;
      }

      callback(undefined, doc);
    });
  });
}

function find(collName){

  var rawQuery = arguments.length > 2 ? arguments[1] : undefined,
      callback = arguments[ arguments.length - 1 ],
      query    = fixQuery(rawQuery) || {};

  colls(collName, function(error, coll){
    if(error){
      callback(error);
      return;
    }

    coll.find(query).toArray(function(error, docs){
      if(error){
        callback(error);
        return;
      }

      callback(undefined, docs);
    });
  });
}

function fixQuery(query){
  if(query == undefined || query == null){
    return undefined;
  }

  typeof query != 'object' && ( query = { '_id': query } );
  query instanceof mongodb.ObjectID && ( query = { '_id': String(query) } );
  query._id && ( query._id = objectId(query._id) );

  return query;
}

function objectId(id){
  return typeof id == 'string' ? new mongodb.ObjectID(id) : id;
}

function remove(collName){
  var rawQuery = arguments.length > 2 ? arguments[1] : undefined,
      callback = arguments[ arguments.length - 1 ],
      query    = fixQuery(rawQuery) || {};

  colls(collName, function(error, coll){
    if(error){
      callback(error);
      return;
    }

    coll.remove(query, callback);
  });
}

function save(collName, doc, callback){
  colls(collName, function(error, coll){
    if(error){
      callback(error);
      return;
    }

    doc._id && ( doc._id = objectId(doc._id) );

    coll.save(doc, function(error, result){
      if(error){
        callback(error);
        return;
      }

      callback(undefined, String(doc._id || result._id));
    });

  });
}

function toString(){
  return 'map-mongo';
}
