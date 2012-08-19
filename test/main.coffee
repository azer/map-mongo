highkick = require 'highkick'

module.exports =
  testConn   : highkick 'conn'
  testColls   : highkick 'colls'
  testSchema : highkick 'schema'
