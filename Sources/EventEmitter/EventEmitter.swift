
import Foundation

public class Observer<T> : Hashable {
    
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    public static func ==(lhs: Observer<T>, rhs:Observer<T>) -> Bool {
        return ObjectIdentifier(self) == ObjectIdentifier(rhs)
    }
    
    weak var event: Event<T>?
    
    var action: (T)->()
    
    init(event: Event<T>, action: @escaping (T)->()) {
        self.event = event
        self.action = action
    }
    
    
    public func unregister() {
        event?.unregister(self)
    }
    
    
}

public class Event<T> {
    
    let name : Notification.Name
    
    var observers : Set<Observer<T>> = Set()

    public init(name:Notification.Name?=nil) {
        self.name = name ?? Notification.Name(rawValue:UUID().uuidString)
    }
    
    public func on(_ execute: @escaping (T)->()) -> Observer<T> {
        print("Registering event...")
        let observer = Observer(event: self, action: execute)
        observers.insert(observer)
        return observer
    }
    
    public func emit(_ data:T) {
        print("Emitting event: \(self.name)")
        for observer in observers {
            observer.action(data)
        }
    }
    
    public func unregister(_ observer: Observer<T>) {
        self.observers.remove(observer)
    }

}
