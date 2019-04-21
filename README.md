# PASynchronizedDictionary

[![Build Status][build-status-badge]][build-status-url]
[![codecov][code-cov-badge]][code-cov-url]
[![doccov][doc-cov-badge]][doc-cov-url]
[![Version][version-badge]][version-url]
[![Platform][platform-badge]][platform-url]

## Installation

PASynchronizedDictionary is available through [CocoaPods][cocoa-pods-url]. To install
it, simply add the following line to your Podfile:

```ruby
pod 'PASynchronizedDictionary'
```

## Usage

### Import
First you need to import the library

```swift
import PASynchronizedDictionary
```

### Initialization

When initializing a synchronized dictionary you have the option to pass a custom queue and an existing dictionary.

```swift
let customQueue = DispatchQueue(label: "io.customQueue", qos: .userInitiated, attributes: .concurrent)
let dict = [String: Int]()

// Initialize default synchronized dictionary
let synchronizedDict = PASynchronizedDictionary<Int>()

// Initialize with a custom queue
let synchronizedDict = PASynchronizedDictionary<Int>(queue: customQueue)

// Initialize with an existing dictionary
let synchronizedDict = PASynchronizedDictionary<Int>(dict: dict)

// Initialize with both a custom queue and an existing dictionary
let synchronizedDict = PASynchronizedDictionary<Int>(queue: customQueue, dict: dict) 
```

## Documentation

Documentation for the project can be found [here](https://akpatrick.github.io/PASynchronizedDictionary/)

## Author

Patrick Akoury, patrick.akoury@outlook.com

## License

PASynchronizedDictionary is available under the MIT license. See the LICENSE file for more info.

[build-status-url]:	https://travis-ci.com/akpatrick/PASynchronizedDictionary
[code-cov-url]:	https://codecov.io/gh/akpatrick/PASynchronizedDictionary
[doc-cov-url]: https://akpatrick.github.io/PASynchronizedDictionary/
[version-url]:	https://cocoapods.org/pods/PASynchronizedDictionary
[license-url]:	https://cocoapods.org/pods/PASynchronizedDictionary
[platform-url]:	https://cocoapods.org/pods/PASynchronizedDictionary
[cocoa-pods-url]:	https://cocoapods.org

[build-status-badge]:	https://travis-ci.com/akpatrick/PASynchronizedDictionary.svg?branch=master
[code-cov-badge]:	https://codecov.io/gh/akpatrick/PASynchronizedDictionary/branch/master/graph/badge.svg
[doc-cov-badge]:	https://github.com/akpatrick/PASynchronizedDictionary/blob/gh-pages/badge.svg
[version-badge]:	https://img.shields.io/cocoapods/v/PASynchronizedDictionary.svg?style=flat
[license-badge]:	https://img.shields.io/cocoapods/l/PASynchronizedDictionary.svg?style=flat
[platform-badge]:	https://img.shields.io/cocoapods/p/PASynchronizedDictionary.svg?style=flat