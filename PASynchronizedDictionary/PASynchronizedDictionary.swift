//
//  PASynchronizedDictionary.swift
//  PASynchronizedDictionary
//
//  Created by Patrick Ak on 4/19/19.
//  Copyright © 2019 Patrick Akoury. All rights reserved.
//

import Foundation

/// A class to create a synchronized dictionary
public final class PASynchronizedDictionary<Element> {
    private final let defaultQueue = DispatchQueue(label: "io.PASynchronizedDictionary", qos: .userInitiated, attributes: .concurrent)
    
    private final let queue: DispatchQueue!
    private final var dict: [String: Element]!
    
    /**
     Initialize the dictionary with an option of passing a custom queue and/or an existing dictionary
     - Parameter queue: A custom queue to be used for the synchronization
     - Parameter dict: A dictionary to be used as the starting state
     */
    public init(queue: DispatchQueue? = nil, dict: [String: Element] = [String: Element]()) {
        self.queue = queue == nil ? defaultQueue : queue
        self.dict = dict
    }
}

// MARK: - Reads
public extension PASynchronizedDictionary where Element: Equatable {
    
    /// Returns the number of elements in the dictionary
    public func count() -> Int {
        var result = 0
        queue.sync {
            result = dict.count
        }
        return result
    }
    
    /// Reurns a boolean indicating if the dictionary is empty or not
    public func isEmpty() -> Bool {
        var result = true
        queue.sync {
            result = dict.isEmpty
        }
        return result
    }
    
    /**
     Returns a boolean indicating if the dictionary contains the requested ***Key***
     - Parameter key: The key of the object to check
    */
    public func containsKey(key: String) -> Bool {
        var result = false
        queue.sync {
            result = dict.keys.contains(key)
        }
        return result
    }
    
    /// Reurns the Keyset of the dictionary
    public func keys() -> Dictionary<String, Element>.Keys {
        var result: Dictionary<String, Element>.Keys!
        queue.sync {
            result = dict.keys
        }
        return result
    }
    
    /**
     Reurns a boolean indicating if the dictionary contains the requested ***Value***
     - Parameter value: The value of the object to check
    */
    public func containsValue(value: Element) -> Bool {
        var result = false
        queue.sync {
            result = dict.values.contains(value)
        }
        return result
    }
    
    /// Returns the Valueset of the dictionary
    public func values() -> Dictionary<String, Element>.Values {
        var result: Dictionary<String, Element>.Values!
        queue.sync {
            result = dict.values
        }
        return result
    }
    
    /**
     Returns an optional element for the requested ***Key***
     - Parameter key: The key of the object to retrieve
    */
    public func get(key: String) -> Element? {
        var result: Element?
        queue.sync {
            result = dict[key]
        }
        return result
    }
    
    /// Returns the complete dictionary
    public func getAll() -> [String: Element] {
        var result: [String: Element]!
        queue.sync {
            result = dict
        }
        return result
    }
    
    /**
     Returns the object for the requested ***Key*** if found
     Returns the ***Default Value*** if no object was found for the requested ***Key***
     - Parameter key: The key of the object to retrieve
     - Parameter defaultValue: Default value to return if no object was found for the requested ***Key***
    */
    public func getOrDefault(key: String, defaultValue: Element) -> Element {
        var result: Element!
        queue.sync {
            result = dict[key] ?? defaultValue
        }
        return result
    }
    
    /// Reurns the label of the queue being used for synchronization
    public func getQueueLabel() -> String {
        return queue.label
    }
}

// MARK: - Writes
public extension PASynchronizedDictionary {
    
    /**
     Put the element if its not already in the dictionary or update its value if its present
     - Parameter key: The key of the object to insert/update
     - Parameter value: The value of the object to insert/update
    */
    public func putOrUpdate(key: String, value: Element) {
        queue.async(flags: .barrier) {
            self.dict[key] = value
        }
    }
    
    /**
     Puts the element in the fictionary only if its missing
     - Parameter key: The key of the object to insert
     - Parameter value: The value of the object to insert
     */
    public func putIfAbsent(key: String, value: Element) {
        queue.async(flags: .barrier) {
            if(!self.dict.keys.contains(key)) {
                self.dict[key] = value
            }
        }
    }
    
    /**
     Removes the element associated with the provided key
     - Parameter key: The key of the object to remove
    */
    public func remove(key: String) -> Element? {
        var result: Element?
        queue.async(flags: .barrier) {
            result = self.dict.removeValue(forKey: key)
        }
        return result
    }
    
    /**
     It merges the current dictionary with the one provided
     - Parameter dict: The dictionary to be merged with the current one
     */
    public func merge(dict: [String: Element]) {
        queue.async(flags: .barrier) {
            self.dict.merge(dict, uniquingKeysWith: { (_, new) in new })
        }
    }
    
    /// Removes all the objects in the dictionary
    public func removeAll() {
        queue.async(flags: .barrier) {
            self.dict.removeAll()
        }
    }
}

