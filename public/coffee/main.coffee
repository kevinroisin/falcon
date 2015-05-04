Person = require('./Person.coffee')
Dispatcher = require('./Dispatcher.coffee')
$ = require('jquery')

kevin = new Person({name: "KevinRoisin"})

class App
	constructor: () ->
		console.log Dispatcher.register(@cb)

		kevin.log_dispatchers()

	cb: () =>
		console.log 'my cb'
$ -> 
	app = new App()
	$('body').html(kevin.get_name())

