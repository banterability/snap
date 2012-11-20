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

  average: ->
    _.reduce(@queue, (memo, value) ->
      memo + value
    ) / @queue.length

generator = new RandomInteger

dataStream = new Buffer
  maxSize: 10

rollingAverages = new Buffer
  maxSize: 10

valueCanvas = d3.select("#dataList")
averageCanvas = d3.select("#averageList")

updateData = ->
  list = valueCanvas.selectAll("li")
    .data(dataStream.values())

  list.enter()
    .append("li")
      .text((value) -> value)
      .style("color", "#999")
    .transition()
      .style("color", "#333")
      .duration(500)

  list.text((value) -> value)

  list.exit()
    .remove()

  averages = averageCanvas.selectAll("li")
    .data(rollingAverages.values())

  averages.enter()
    .append("li")
      .text((value) -> value)
      .style("color", "#ccc")
    .transition()
      .style("color", "#999")
      .duration(750)

  averages.text((value) -> Math.floor(value))

  averages.exit()
    .remove()

addNewPoint = ->
  dataStream.add(generator.generate())

setInterval ->
  addNewPoint()
  rollingAverages.add(dataStream.average())
  updateData()
, 1000