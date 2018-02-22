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

## Concurrent Emit

It's also possible to emit an event concurrently, so that observer actions will be executed in parallel: 

    // emit concurrent events synchronously
    event.emitConcurrent(data)
    print("this prints after all the observer actions have been executed")

    // emit concurrent events asyncronously
    DispatchQueue.main.async {
    	event.emitConcurrent(data)
    }
    print("this will print before the emit finishes")

## Note

Observer blocks are executed synchronously on the thread where `emit` is called

