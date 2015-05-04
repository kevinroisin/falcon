class Dispatcher
	@_callbacks = {}
	@_is_pending = {}
	@_is_handled = {}
	@_is_dispatching = false
	@_pending_payload = null
	@_prefix = 'ID'
	@_last_id = 1

	@register: (callback) ->
		id = "#{@_prefix}_#{@_last_id++}"
		@_callbacks[id] = callback
		return id

	@unregister: (id) ->
		if !@_callbacks[id]?
			throw new Error("Dispatcher.unregister(...): #{id} does not map to a registered callback.")
		delete @_callbacks[id]

	@wait_for: (ids) ->
		if !@_is_dispatching
			throw new Error('Dispatcher.wait_for(...): must be invoked while dispatching.')
		for id in ids
			if @_is_pending[id]
				if !@_is_handled[id]
					throw new Error("Dispatcher.wait_for(...): Circular dependency detected while waiting for #{id}")
				continue
			
			if !@_callbacks[id]?
				throw new Error("Dispatcher.wait_for(...): #{id} does not map to a registered callback.")
		
			@_invoke_callback(id)

	@dispatch: (payload) ->
		if @_is_dispatching
			throw new Error('Dispatcher.dispatch(...): Cannot dispatch in the middle of a dispatch.')

		@_start_dispatching(payload)

		try
			for id in @_callbacks
				if @_is_pending[id]
					continue
				@_invoke_callback(id)
		
		finally
			@_stop_dispatching

	@is_dispatching: () ->
		return @_is_dispatching

	@_start_dispatching: (payload) ->
		for id in @_callbacks
			@_is_pending[id] = false
			@_is_handled[id] = false
		@_pending_payload = payload
		@_is_dispatching = true

	@_stop_dispatching: () ->
		@_pending_payload = null
		@_is_dispatching = false

	@_invoke_callback: (id) ->
		@_is_pending[id] = true
		@_callbacks[id](@_pending_payload)
		@_is_handled[id] = true

module.exports = Dispatcher