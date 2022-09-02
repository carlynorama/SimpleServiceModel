//
//  Array + Stream.swift
//  PatternExplorer
//
//  Created by Labtanza on 9/2/22.
//

import Foundation

protocol Timeable {
    var interval: TimeInterval { get }
}

extension Array where Element:Timeable {
    func timeSorted() -> [Element] {
        return self.sorted { (lhs, rhs) in
            lhs.interval < rhs.interval
        }
    }
    
    func stream() -> AsyncStream<Timeable> {
        AsyncStream { continuation in
            let inOrder = self.timeSorted()
            for event in self {
                Timer.scheduledTimer(withTimeInterval: event.interval, repeats: false) { _ in
                    continuation.yield(event)
                    if event.interval == inOrder.last?.interval {
                        continuation.finish()
                    }
                }
            }
            
        }
    }
}
