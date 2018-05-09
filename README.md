# Once

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Carthage/Carthage/master/LICENSE.md) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)[![SPM](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)

A simple thread safe replacement for Dispatch Once and pthread_once for Swift.

## Carthage Usage

Include this line in your `Cartfile`:
```
github "bscothern/Once"
```

## Swift Package Manager
Update your `Package.swift` to include this to your package dependencies:
```
.package(url: "https://github.com/bscothern/Once.git", from: "1.2.0")
```

## Usage
```
import Once

let once = Once()

func foo() {
    once.runOnce {
        // Do stuff that should only execute the first time foo() is called.
    }
    // Do stuff
}
```
