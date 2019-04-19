//
//  PASynchronizedDictionaryTests.swift
//  PASynchronizedDictionaryTests
//
//  Created by Patrick Ak on 4/19/19.
//  Copyright © 2019 Patrick Akoury. All rights reserved.
//

import XCTest
import PASynchronizedDictionary
@testable import PASynchronizedDictionary

class PASynchronizedDictionaryTests: XCTestCase {

    let synchronizedDict = PASynchronizedDictionary<Int>()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        initializeDict()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        synchronizedDict.removeAll()
    }
    
    // MARK: - Read methods tests
    
    func testCount() {
        XCTAssertEqual(1000, synchronizedDict.count())
    }
    
    func testIsEmpty() {
        XCTAssertEqual(false, synchronizedDict.isEmpty())
    }
    
    func testContainsKey() {
        XCTAssertTrue(synchronizedDict.containsKey(key: "397"))
        XCTAssertFalse(synchronizedDict.containsKey(key: "NON_PRESENT_KEY"))
    }
    
    func testKeys() {
        let actualKeys = Array(synchronizedDict.keys()).sorted {$0.localizedStandardCompare($1) == .orderedAscending}
        XCTAssertEqual(expectedKeys(), actualKeys)
    }
    
    func testContainsValue() {
        XCTAssertTrue(synchronizedDict.containsValue(value: 5))
        XCTAssertFalse(synchronizedDict.containsValue(value: 1000))
    }
    
    func testValues() {
        let actualValues = Array(synchronizedDict.values()).sorted()
        XCTAssertEqual(expectedValues(), actualValues)
    }
    
    func testGetValue() {
        XCTAssertEqual(278, synchronizedDict.get(key: "278"))
        XCTAssertEqual(865, synchronizedDict.get(key: "865"))
        XCTAssertNil(synchronizedDict.get(key: "NON_PRESENT_KEY"))
    }
    
    func testGetAll() {
        let actualDict = synchronizedDict.getAll()
        XCTAssertEqual(expectedDictionary(), actualDict)
    }
    
    func testGetOrDefault() {
        XCTAssertEqual(500, synchronizedDict.getOrDefault(key: "500", defaultValue: 5000))
        XCTAssertEqual(5000, synchronizedDict.getOrDefault(key: "NON_PRESENT_KEY", defaultValue: 5000))
    }
    
    // MARK: - Write methods tests
    
    func testPutOrUpdate() {
        //Update
        XCTAssertEqual(777, synchronizedDict.get(key: "777"))
        synchronizedDict.putOrUpdate(key: "777", value: 7)
        XCTAssertEqual(7, synchronizedDict.get(key: "777"))
        
        //put
        XCTAssertNil(synchronizedDict.get(key: "77777"))
        synchronizedDict.putOrUpdate(key: "77777", value: 7)
        XCTAssertEqual(7, synchronizedDict.get(key: "77777"))
    }
    
    func testPutIfAbsent() {
        //Not absent
        XCTAssertEqual(777, synchronizedDict.get(key: "777"))
        synchronizedDict.putIfAbsent(key: "777", value: 7)
        XCTAssertEqual(777, synchronizedDict.get(key: "777"))
        
        //Absent
        XCTAssertNil(synchronizedDict.get(key: "7777"))
        synchronizedDict.putIfAbsent(key: "7777", value: 7)
        XCTAssertEqual(7, synchronizedDict.get(key: "7777"))
    }
    
    func testRemove() {
        XCTAssertEqual(7, synchronizedDict.get(key: "7"))
        _ = synchronizedDict.remove(key: "7")
        XCTAssertNil(synchronizedDict.get(key: "7"))
    }
    
    func testMerge() {
        synchronizedDict.merge(dict: dictionaryToMerge())
        XCTAssertEqual(expectedDictionaryAfterMerge(), synchronizedDict.getAll())
    }
    
    func testRemoveAll() {
        synchronizedDict.removeAll()
        XCTAssertTrue(synchronizedDict.isEmpty())
        XCTAssertEqual([String: Int](), synchronizedDict.getAll())
    }
    
    // MARK: - Private initializers
    
    private func initializeDict() {
        do {
            var iterations = 1000
            let start = Date().timeIntervalSince1970
            
            DispatchQueue.concurrentPerform(iterations: iterations) { index in
                synchronizedDict.putOrUpdate(key: "\(index)", value: index)
                
                DispatchQueue.global().sync {
                    iterations -= 1
                    
                    // Final loop
                    guard iterations <= 0 else { return }
                    let message = String(format: "Safe loop took %.3f seconds, count: %d.",
                                         Date().timeIntervalSince1970 - start,
                                         synchronizedDict.count())
                    print(message)
                }
            }
        }
    }
    
    private func expectedKeys() -> [String] {
        var keys = [String]()
        for i in 0..<1000 {
            keys.append("\(i)")
        }
        return keys
    }
    
    private func expectedValues() -> [Int] {
        var values = [Int]()
        for i in 0..<1000 {
            values.append(i)
        }
        return values
    }
    
    private func expectedDictionary() -> [String: Int] {
        var dict = [String: Int]()
        for i in 0..<1000 {
            dict["\(i)"] = i
        }
        return dict
    }
    
    private func dictionaryToMerge() -> [String: Int] {
        var dict = [String: Int]()
        for i in 0..<10 {
            dict["\(i)"] = i + 1000
        }
        return dict
    }
    
    private func expectedDictionaryAfterMerge() -> [String: Int] {
        var dict = [String: Int]()
        for i in 0..<1000 {
            if (i < 10) {
                dict["\(i)"] = i + 1000
            } else {
                dict["\(i)"] = i
            }
        }
        return dict
    }

}
