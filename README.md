# SwAlert

[![Version](https://img.shields.io/cocoapods/v/SwAlert.svg?style=flat)](http://cocoadocs.org/docsets/SwAlert)
[![License](https://img.shields.io/cocoapods/l/SwAlert.svg?style=flat)](http://cocoadocs.org/docsets/SwAlert)
[![Swift 2.2](https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![Xcode 7.3](https://img.shields.io/badge/Xcode-7.3+-blue.svg?style=flat)](https://developer.apple.com/swift/)

Wrapper of UIAlertView & UIAlertController. written in Swift.

## Usage

### Show No Action Alert

```swift
SwAlert.showAlert("no action title", message: "no action message", buttonTitle: "button title")

// iOS8 : UIAlertController addAction(UIAlertActionStyleCancel)
// iOS7 : UIAlertView clickedButtonAtIndex(cancelButtonIndex)
```

### Show Simple Action Alert and CompletionHandler

```swift
SwAlert.showAlert("one action title", message: "no action message", buttonTitle: "button title") { result in
    // iOS8 : UIAlertController addAction(UIAlertActionStyleCancel)
    // iOS7 : UIAlertView clickedButtonAtIndex(cancelButtonIndex)
    println("showOneActionAlert completion")
}
```

### Show Some Action Alert and CompletionHandler

```swift
SwAlert(title: "double action title", message: "double action message")
    .addAction("double action 1") { result in
        // iOS8 : UIAlertController addAction(UIAlertActionStyleDefault)
        // iOS7 : UIAlertView clickedButtonAtIndex(buttonIndex)
        println("double action 1 completion")
    }
    .setCancelAction("cancel action") { result in
        // iOS8 : UIAlertController addAction(UIAlertActionStyleCancel)
        // iOS7 : UIAlertView  clickedButtonAtIndex(cancelButtonIndex)
        println("cancel action completion")
    }
    .show()
```

### Show Textfield Action Alert and CompletionHandler

```swift
SwAlert(title: "text action title", message: "text action message")
    .addTextField("text action 1 title", placeholder: "text action 1 placeholder")
    .addTextField("text action 2 title", placeholder: "text action 2 placeholder")
    .addAction("text action") { result in
        println(result) // Other(["text action 1 title", "text action 2 title"])
    }
    .show()
```

## Objc Version

[ARNAlert](https://github.com/xxxAIRINxxx/ARNAlert)


## Requirements

* iOS 7.0+
* Xcode 7.3
* Swift 2.2+
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
