A functional data-binding library for MongoDB and NodeJS, based on [MapJS](http://github.com/azer/mapjs). It's written in JavaScript (only tests are CoffeeScript).

Status: Alpha

# Install

```bash
npm install mongo-map
```

# Usage Example

## Configuration

CoffeeScript:

```coffee
mapmongo = require 'map-mongo'

mapmongo.config {
  name   : 'map-mongo-dev'
  host   : '127.0.0.1'
  port   : 27017
  user   : ''
  passwd : ''
}
```

JavaScript:

```js
var mapmongo = require('map-mongo');

mapmongo.config({
  name   : 'map-mongo-dev'
  host   : '127.0.0.1'
  port   : 27017
  user   : ''
  passwd : ''
});
```

## Schemas & Documents

### Defining

CoffeeScript:

```coffee
people = mapmongo 'people', {
  name : String
  age  : Number
}

joe = people {
  name: 'Joe'
  age: 21
}
```

JavaScript:

```js
var people = mapmongo('people', {
  name : String,
  age  : Number
});

var joe = people({
  name: 'Joe'
  age: 21
});
```

### Available Methods

See tests for more examples.

#### Find

CoffeeScript:

```coffee
people.find { age: 21 }, (error, a21) ->
  throw error if error

  console.log a21.length, 1
```

JavaScript:

```js
people.find({ age: 21 }, function(error, a21){
  if(error) throw error;

  console.log(a21.length, 1);

});
```

#### Get
#### Remove
#### Save

CoffeeScript:

```coffee
people.save joe, (error) ->
  throw error if error

  console.log joe.id() # 5030b575e004f24c65000004
```

JavaScript:

```js
people.save(joe, function(error){
  if(error) throw error;

  console.log(joe.id()); // 5030b575e004f24c65000004
});
```
