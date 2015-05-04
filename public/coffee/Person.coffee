Dispatcher = require('./Dispatcher.coffee')

class Person
	constructor: (options) ->
		{@name} = options
		Dispatcher.register(@get_name)

	get_name: () =>
		return @name

	log_dispatchers: =>
		console.log Dispatcher._callbacks

module.exports = Person;