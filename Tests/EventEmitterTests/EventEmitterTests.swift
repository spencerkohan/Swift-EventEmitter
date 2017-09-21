import XCTest
@testable import EventEmitter

class EventEmitterTests: XCTestCase {
    
    func testEvents() {

        let expectation = self.expectation(description: "Event")

        let event = Event<String>()

        _ = event.on { string in 
            print("Event received: \(string)")
            expectation.fulfill()
        }

        event.emit("hola")

        waitForExpectations(timeout: 1) {_ in}

    }


    static var allTests = [
        ("testEvents", testEvents),
    ]
}
