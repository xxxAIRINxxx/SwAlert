# SwAlert

[![CI Status](http://img.shields.io/travis/Airin/ARNAlert.svg?style=flat)](https://travis-ci.org/xxxAIRINxxx/SwAlert)
[![Version](https://img.shields.io/cocoapods/v/ARNAlert.svg?style=flat)](http://cocoadocs.org/docsets/SwAlert)
[![License](https://img.shields.io/cocoapods/l/ARNAlert.svg?style=flat)](http://cocoadocs.org/docsets/SwAlert)
[![Platform](https://img.shields.io/cocoapods/p/ARNAlert.svg?style=flat)](http://cocoadocs.org/docsets/SwAlert)

Wrapper of UIAlertView & UIAlertController. (Swift-lang)

## Usage


### Show No Action Alert

```swift

SwAlert.showNoActionAlert("no action title", message: "no action message", buttonTitle: "button title")

// iOS8 : UIAlertController addAction(UIAlertActionStyleCancel)
// iOS7 : UIAlertView clickedButtonAtIndex(cancelButtonIndex)

```

### Show Simple Action Alert and CompletionHandler

```swift

SwAlert.showOneActionAlert("one action title", message: "no action message", buttonTitle: "button title") { (resultObject) -> Void in
    // iOS8 : UIAlertController addAction(UIAlertActionStyleCancel)
    // iOS7 : UIAlertView clickedButtonAtIndex(cancelButtonIndex)
    println("showOneActionAlert completion")
}

```

### Show Some Action Alert and CompletionHandler

```swift

var alert = SwAlert.generate("double action title", message: "double action message")

alert.addAction("double action 1", completion: { (resultObject) -> Void in
    // iOS8 : UIAlertController addAction(UIAlertActionStyleDefault)
    // iOS7 : UIAlertView clickedButtonAtIndex(buttonIndex)
    println("double action 1 completion")
})

alert.setCancelAction("cancel action", completion: { (resultObject) -> Void in
    // iOS8 : UIAlertController addAction(UIAlertActionStyleCancel)
    // iOS7 : UIAlertView  clickedButtonAtIndex(cancelButtonIndex)
    println("cancel action completion")
})

alert.show()

```

### Show Textfield Action Alert and CompletionHandler

```swift

var alert = SwAlert.generate("text action title", message: "text action message")

alert.addTextField("text action 1 title", placeholder: "text action 1 placeholder")
alert.addTextField("text action 2 title", placeholder: "text action 2 placeholder")
alert.addTextField("text action 3 title", placeholder: "text action 3 placeholder")

alert.addAction("text action", completion: { (resultObject) -> Void in
    println("text action completion")
    // iOS8 : resultObject is 3 textFields
    // iOS7 : resultObject is 2 textFields (iOS7 is max 2 fields)
    println(resultObject)
})

alert.show()

```

## Objc Version

[ARNAlert](https://github.com/xxxAIRINxxx/ARNAlert)


## Requirements

* iOS 7.0+
* Swift lang 1.2+
* ARC
* CocoaPods 0.36+ (if you needed)

## Installation

### iOS7

To use SwAlert with a project targeting iOS 7, you must include the
SwAlert.swift source file directly in your project.

### iOS 8 or later

ARNAlert is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "SwAlert"

## License

SwAlert is available under the MIT license. See the LICENSE file for more info.
