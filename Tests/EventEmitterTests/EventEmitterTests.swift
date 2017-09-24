import XCTest
@testable import EventEmitter

class EventEmitterTests: XCTestCase {
    
    func testTrivialEvent() {
        let event = Event<String>()
        let observer = event.on { string in
            XCTAssert(string == "hola", "Emitted event value is received")
        }
        event.emit("hola")
        observer.unregister()
    }
    
    func testVoidEvent() {
        let event = Event<Void>()
        var eventCount = 0
        let observer = event.on {
            eventCount += 1
        }
        event.emit()
        observer.unregister()
        XCTAssert(eventCount == 1, "Exactly one event receieved")
    }
    
    func testUnregistration() {
        
        let event = Event<Void>()
        
        var selfUnregisteringObserverReceivedCount = 0
        let selfUnregisteringObserver = event.on {
            selfUnregisteringObserverReceivedCount += 1
        }
        
        var externallyUnregisteringObserverReceivedCount = 0
        let externallyUnregisteringObserver = event.on {
            externallyUnregisteringObserverReceivedCount += 1
        }
        
        event.emit()
        selfUnregisteringObserver.unregister()
        event.emit()
        event.unregister(externallyUnregisteringObserver)
        event.emit()
        XCTAssert(selfUnregisteringObserverReceivedCount == 1, "Exactly one event receieved")
        XCTAssert(externallyUnregisteringObserverReceivedCount == 2, "Exactly two event receieved")
        
    }
    
    func testOneTimeObserver() {
        
        let event = Event<Void>()
        
        var eventCount = 0
        event.once {
            eventCount += 1
        }
        
        event.emit()
        event.emit()
        
        XCTAssert(eventCount == 1, "Exactly one event receieved")
        
    }


    static var allTests = [
        ("testTrivialEvent", testTrivialEvent),
        ("testVoidEvent", testVoidEvent),
        ("testUnregistration", testUnregistration),
        ("testOneTimeObserver", testOneTimeObserver),
    ]
}
