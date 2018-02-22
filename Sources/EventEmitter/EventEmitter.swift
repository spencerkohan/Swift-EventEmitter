
import Foundation

public protocol AnyObserver {
    func unregister()
    func register()
}

public class ObserverGroup {
    
    public init(_ observers: [AnyObserver]) {
        self.observers = observers
    }
    
    var observers : [AnyObserver]
    
    public static func +=(_ base: inout ObserverGroup, _ addition: [AnyObserver]) {
        base.observers += addition
    }
    
    public static func +=(_ base: inout ObserverGroup, _ observer: AnyObserver) {
        base.observers += [observer]
    }
    
    public func unregisterAll() {
        for observer in observers {
            observer.unregister()
        }
    }
    
    public func registerAll() {
        for observer in observers {
            observer.register()
        }
    }
    
    deinit {
        self.unregisterAll()
    }
}

public class Observer<T> : Hashable, AnyObserver {
    
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
    
    public func register() {
        event?.observers.insert(self)
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

    public func emit(_ data: T) {
        for observer in observers {
            observer.action(data)
        }
    }
    
    public func  emitConcurrent(_ data: T) {
        let currentObservers = Array(self.observers)
        DispatchQueue.concurrentPerform(iterations: currentObservers.count) { i in
            currentObservers[i].action(data)
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
    
    public func emitConcurrent() {
        self.emitConcurrent(())
    }
    
}
