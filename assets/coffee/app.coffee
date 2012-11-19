class RandomInteger
  constructor: (options = {}) ->
    @min = options.min || 0
    @max = options.max || 100

  generate: ->
    _.random @min, @max

class Buffer
  constructor: (options = {}) ->
    @queue = []
    @maxSize = options.maxSize || 10

  add: (value) ->
    @queue.push value
    @queue.shift() if @queue.length > @maxSize

  values: ->
    @queue

generator = new RandomInteger
  min: 5
  max: 8

dataStream = new Buffer
  maxSize: 5

addNewPoint = ->
  dataStream.add(generator.generate())
  console.log dataStream.values()

setInterval ->
  addNewPoint()
, 1000