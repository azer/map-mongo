var debug = require('debug')('config');

module.exports = (function(){
  var value = {};

  return function(newValue){
    if( arguments.length ){
      debug('Setting new MongoDB config: %s', newValue);
      value = newValue;
    }

    return value;
  };

}());
