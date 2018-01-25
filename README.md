# Once

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Carthage/Carthage/master/LICENSE.md) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A replacement for Dispatch Once in Swift.

## Carthage Usage

Include this line in your `Cartfile`:
```
github "bscothern/Once"
```

## Usage

```
let once = Once()

func foo() {
    once.runOnce {
        // Do stuff that should only execute the first time foo() is called.
    }
    // Do stuff
}
```
