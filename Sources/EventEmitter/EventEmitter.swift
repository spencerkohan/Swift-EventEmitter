
import Foundation

private let payloadKey : String = "EventEmitterPayloadKey"


#if os(Linux)

extension NotificationCenter {

    func addObserver(forName name: NSNotification.Name, object: Any?, queue: OperationQueue?, using block: @escaping (Notification)->()) -> Any {
        return addObserver(forName: name, object: object, queue: queue, usingBlock: block)
    }

}


#endif


public class Observer<T> {
    
    let observer: Any
    weak var event: Event<T>?
    
    init(event: Event<T>, observer: Any) {
        self.observer = observer
        self.event = event
    }
    
    
    public func unregister(observer: Observer<T>) {
        NotificationCenter.default.removeObserver(observer)
    }
    
    
}

public class Event<T> {
    
    let name : Notification.Name

    public init(name:Notification.Name?=nil) {
        self.name = name ?? Notification.Name(rawValue:UUID().uuidString)
    }
    
    public func on(_ execute: @escaping (T)->()) -> Observer<T> {
        let observer = NotificationCenter.default.addObserver(forName: self.name, object: self, queue: nil, using: {notification in
            guard let userInfo = notification.userInfo, let payload = userInfo[payloadKey] as? T else {
                return
            }
            execute(payload)
        })
        return Observer(event:self, observer: observer)
    }
    
    public func emit(_ data:T) {
        NotificationCenter.default.post(name: self.name, object: self, userInfo: [
            payloadKey: data
            ])
    }

}
