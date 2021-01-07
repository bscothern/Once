# Once

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Carthage/Carthage/master/LICENSE.md) [![SPM](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A simple thread safe replacement for Dispatch Once and pthread_once for Swift.

## Swift Package Manager
Update your `Package.swift` to include the appropriate dependency below:

### Swift 5.2+
```swift
.package(name: "Once", "https://github.com/bscothern/Once.git", from: "1.4.0")
```

### Swift 4.0-5.1
```swift
.package(url: "https://github.com/bscothern/Once.git", from: "1.3.2")
```

## Carthage Usage
Include this line in your `Cartfile`:
```
github "bscothern/Once"
```

## Usage
```swift
import Once

let once = Once()

func foo() {
    once.runOnce {
        // Do stuff that should only execute the first time foo() is called.
    }
    // Do stuff
}
```
