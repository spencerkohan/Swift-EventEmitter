# EventEmitter

A minimal type-safe event implementation in Swift.

## Usage:

Create and emit a typed event:

	let event = Event<Sting>()

	event.emit("hola")

Create and emit a void event:

	let voidEvent = Event<Void>()

	voidEvent.emit()

Add an observer:

	let observer = event.on { message in
		// do something
	}

Add a one-time observer:

	let oneTimeObserver = event.once { message in
		// do something
	}

Unregister an observer:

	// from the observer
	observer.unregister()

	// through the event
	event.unregister(oneTimeObserver)

Re-register an observer:

	observer.register()

### Observer Groups:

Observer groups allow for the block registration/unregistration of multiple observers at once.

	// initialize a group of observers
    let group = ObserverGroup([
    		eventA.on { ... },
    		eventB.on { ... },
    		...
    	])

	// unregister all observers in a group
	group.unregisterAll()

	// re-register a group of observers
	group.registerAll()

Observer groups unregister all their memebers on `deinit`.


## Note

Observer blocks are executed synchronously on the thread where `emit` is called





