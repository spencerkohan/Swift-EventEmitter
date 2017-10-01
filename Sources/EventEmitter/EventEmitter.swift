
import Foundation

public class Observer<T> : Hashable {
    
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    public static func ==(lhs: Observer<T>, rhs:Observer<T>) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
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
    
    var observers : Set<Observer<T>> = Set()

    public init() {}
    
    public func on(_ execute: @escaping (T)->()) -> Observer<T> {
        let observer = Observer(event: self, action: execute)
        observers.insert(observer)
        return observer
    }
    
    public func once(_ execute: @escaping (T)->()) -> Observer<T> {
        let observer : Observer<T> = Observer(event: self, action: execute)
        observer.action = { value in
            execute(value)
            observer.unregister()
        }
        observers.insert(observer)
        return observer
    }

    public func emit(_ data:T) {
        for observer in observers {
            observer.action(data)
        }
    }
    
    public func unregister(_ observer: Observer<T>) {
        self.observers.remove(observer)
    }

}

public extension Event where T == Void {
    
    public func emit() {
        self.emit(())
    }
    
}
