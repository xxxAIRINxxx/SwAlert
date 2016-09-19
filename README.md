# SwAlert

[![Version](https://img.shields.io/cocoapods/v/SwAlert.svg?style=flat)](http://cocoadocs.org/docsets/SwAlert)
[![License](https://img.shields.io/cocoapods/l/SwAlert.svg?style=flat)](http://cocoadocs.org/docsets/SwAlert)
[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![Xcode 8.0](https://img.shields.io/badge/Xcode-8.0+-blue.svg?style=flat)](https://developer.apple.com/swift/)

Wrapper of UIAlertController. written in Swift.

## Usage

### Show No Action Alert

```swift

SwAlert.showAlert("no action title", message: "no action message", buttonTitle: "button title")

```

### Show Simple Action Alert and CompletionHandler

```swift

SwAlert.showAlert("one action title", message: "no action message", buttonTitle: "button title") { result in
    println("showOneActionAlert completion")
}

```

### Show Some Action Alert and CompletionHandler

```swift

SwAlert(title: "double action title", message: "double action message")
    .addAction("double action 1") { result in
        println("double action 1 completion")
    }
    .setCancelAction("cancel action") { result in
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

* iOS 9.0+
* Xcode 8.0+
* Swift 3.0+
* CocoaPods 1.0.1+

## Installation


```ruby
use_frameworks!

pod "SwAlert"
```

## License

MIT license. See the LICENSE file for more info.
