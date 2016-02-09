# SwAlert

[![Version](https://img.shields.io/cocoapods/v/SwAlert.svg?style=flat)](http://cocoadocs.org/docsets/SwAlert)
[![License](https://img.shields.io/cocoapods/l/SwAlert.svg?style=flat)](http://cocoadocs.org/docsets/SwAlert)
[![Swift 2.1](https://img.shields.io/badge/Swift-2.1-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![Xcode 7.1+](https://img.shields.io/badge/Xcode-7.1+-blue.svg?style=flat)](https://developer.apple.com/swift/)

Wrapper of UIAlertView & UIAlertController. written in Swift.

## Usage

### Show No Action Alert

```swift
SwAlert.showNoActionAlert("no action title", message: "no action message", buttonTitle: "button title")

// iOS8 : UIAlertController addAction(UIAlertActionStyleCancel)
// iOS7 : UIAlertView clickedButtonAtIndex(cancelButtonIndex)
```

### Show Simple Action Alert and CompletionHandler

```swift
SwAlert.showOneActionAlert("one action title", message: "no action message", buttonTitle: "button title") { result in
    // iOS8 : UIAlertController addAction(UIAlertActionStyleCancel)
    // iOS7 : UIAlertView clickedButtonAtIndex(cancelButtonIndex)
    println("showOneActionAlert completion")
}
```

### Show Some Action Alert and CompletionHandler

```swift
var alert = SwAlert(title: "double action title", message: "double action message")

alert.addAction("double action 1", completion: { result in
    // iOS8 : UIAlertController addAction(UIAlertActionStyleDefault)
    // iOS7 : UIAlertView clickedButtonAtIndex(buttonIndex)
    println("double action 1 completion")
})

alert.setCancelAction("cancel action", completion: { result in
    // iOS8 : UIAlertController addAction(UIAlertActionStyleCancel)
    // iOS7 : UIAlertView  clickedButtonAtIndex(cancelButtonIndex)
    println("cancel action completion")
})

alert.show()
```

### Show Textfield Action Alert and CompletionHandler

```swift
var alert = SwAlert(title: "text action title", message: "text action message")

alert.addTextField("text action 1 title", placeholder: "text action 1 placeholder")
alert.addTextField("text action 2 title", placeholder: "text action 2 placeholder")

alert.addAction("text action", completion: { result in
    println(result) // Other(["text action 1 title", "text action 2 title"])
})

alert.show()
```

## Objc Version

[ARNAlert](https://github.com/xxxAIRINxxx/ARNAlert)


## Requirements

* Xcode 7.1+
* iOS 7.0+
* Swift 2.1+
* CocoaPods 0.36+ (if you needed)

## Installation

### iOS7

To use SwAlert with a project targeting iOS 7, you must include the
SwAlert.swift source file directly in your project.

### iOS 8 or later

```ruby
use_frameworks!

pod "SwAlert"
```

## License

MIT license. See the LICENSE file for more info.
