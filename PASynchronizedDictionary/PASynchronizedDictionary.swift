//
//  PASynchronizedDictionary.swift
//  PASynchronizedDictionary
//
//  Created by Patrick Ak on 4/19/19.
//  Copyright © 2019 Patrick Akoury. All rights reserved.
//

import Foundation

public final class PASynchronizedDictionary<Element> {
    private final let defaultQueue = DispatchQueue(label: "io.PASynchronizedDictionary", qos: .userInitiated, attributes: .concurrent)
    
    private final let queue: DispatchQueue!
    private final var dict: [String: Element]!
    
    public init(queue: DispatchQueue? = nil, dict: [String: Element] = [String: Element]()) {
        self.queue = queue == nil ? defaultQueue : queue
        self.dict = dict
    }
}

// MARK: - Reads
public extension PASynchronizedDictionary where Element: Equatable {
    
    public func count() -> Int {
        var result = 0
        queue.sync {
            result = dict.count
        }
        return result
    }
    
    public func isEmpty() -> Bool {
        var result = true
        queue.sync {
            result = dict.isEmpty
        }
        return result
    }
    
    public func containsKey(key: String) -> Bool {
        var result = false
        queue.sync {
            result = dict.keys.contains(key)
        }
        return result
    }
    
    public func keys() -> Dictionary<String, Element>.Keys {
        var result: Dictionary<String, Element>.Keys!
        queue.sync {
            result = dict.keys
        }
        return result
    }
    
    public func containsValue(value: Element) -> Bool {
        var result = false
        queue.sync {
            result = dict.values.contains(value)
        }
        return result
    }
    
    public func values() -> Dictionary<String, Element>.Values {
        var result: Dictionary<String, Element>.Values!
        queue.sync {
            result = dict.values
        }
        return result
    }
    
    public func get(key: String) -> Element? {
        var result: Element?
        queue.sync {
            result = dict[key]
        }
        return result
    }
    
    public func getAll() -> [String: Element] {
        var result: [String: Element]!
        queue.sync {
            result = dict
        }
        return result
    }
    
    public func getOrDefault(key: String, defaultValue: Element) -> Element {
        var result: Element!
        queue.sync {
            result = dict[key] ?? defaultValue
        }
        return result
    }
    
    public func getQueueLabel() -> String {
        return queue.label
    }
}

// MARK: - Writes
public extension PASynchronizedDictionary {
    
    public func putOrUpdate(key: String, value: Element) {
        queue.async(flags: .barrier) {
            self.dict[key] = value
        }
    }
    
    public func putIfAbsent(key: String, value: Element) {
        queue.async(flags: .barrier) {
            if(!self.dict.keys.contains(key)) {
                self.dict[key] = value
            }
        }
    }
    
    public func remove(key: String) -> Element? {
        var result: Element?
        queue.async(flags: .barrier) {
            result = self.dict.removeValue(forKey: key)
        }
        return result
    }
    
    public func merge(dict: [String: Element]) {
        queue.async(flags: .barrier) {
            self.dict.merge(dict, uniquingKeysWith: { (_, new) in new })
        }
    }
    
    public func removeAll() {
        queue.async(flags: .barrier) {
            self.dict.removeAll()
        }
    }
}

