//
//  SwAlert.swift
//  SwAlert
//
//  Created by xxxAIRINxxx on 2015/03/18.
//  Copyright (c) 2015 xxxAIRINxxx inc. All rights reserved.
//

import UIKit

public typealias CompletionHandler = (resultObject: AnyObject!) -> Void

private class AlertManager {
    
    static var sharedInstance = AlertManager()
    
    var window : UIWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
    lazy var parentController : UIViewController = {
        var parentController = UIViewController()
        parentController.view.backgroundColor = UIColor.clearColor()
        
        if UIDevice.isiOS8orLater() {
            self.window.windowLevel = UIWindowLevelAlert
            self.window.rootViewController = parentController
        }
        
        return parentController
    }()
    
    var alertQueue : [SwAlert] = []
    var showingAlertView : SwAlert?
}

private class AlertInfo {
    var title : String = ""
    var placeholder : String = ""
    var completion : CompletionHandler?
    
    class func generate(title: String, placeholder: String?, completion: CompletionHandler?) -> AlertInfo {
        var alertInfo = AlertInfo()
        alertInfo.title = title
        if placeholder != nil {
            alertInfo.placeholder = placeholder!
        }
        alertInfo.completion = completion
        
        return alertInfo
    }
}

public class SwAlert: NSObject, UIAlertViewDelegate {
    private var title : String = ""
    private var message : String = ""
    private var cancelInfo : AlertInfo?
    private var otherButtonHandlers : [AlertInfo] = []
    private var textFieldInfo : [AlertInfo] = []
    
    // MARK: - Class Methods
    
    class func showNoActionAlert(title: String, message: String, buttonTitle: String) {
        var alert = SwAlert()
        alert.title = title
        alert.message = message
        alert.cancelInfo = AlertInfo.generate(buttonTitle, placeholder: nil, completion: nil)
        alert.show()
    }
    
    class func showOneActionAlert(title: String, message: String, buttonTitle: String, completion: CompletionHandler?) {
        var alert = SwAlert()
        alert.title = title
        alert.message = message
        alert.cancelInfo = AlertInfo.generate(buttonTitle, placeholder: nil, completion: completion)
        alert.show()
    }
    
    class func generate(title: String, message: String) -> SwAlert {
        var alert = SwAlert()
        alert.title = title
        alert.message = message
        return alert
    }
    
    // MARK: - Instance Methods
    
    func setCancelAction(buttonTitle: String, completion: CompletionHandler?) {
        self.cancelInfo = AlertInfo.generate(buttonTitle, placeholder: nil, completion: completion)
    }
    
    func addAction(buttonTitle: String, completion: CompletionHandler?) {
        var alertInfo = AlertInfo.generate(buttonTitle, placeholder: nil, completion: completion)
        self.otherButtonHandlers.append(alertInfo)
    }
    
    func addTextField(title: String, placeholder: String?) {
        var alertInfo = AlertInfo.generate(title, placeholder: placeholder, completion: nil)
        if UIDevice.isiOS8orLater() {
            self.textFieldInfo.append(alertInfo)
        } else {
            if self.textFieldInfo.count >= 2 {
                assert(true, "iOS7 is 2 textField max")
            } else {
                self.textFieldInfo.append(alertInfo)
            }
        }
    }
    
    func show() {
        if UIDevice.isiOS8orLater() {
            self.showAlertController()
        } else {
            self.showAlertView()
        }
    }
    
    // MARK: - Private
    
    private class func dismiss() {
        if UIDevice.isiOS8orLater() {
            SwAlert.dismissAlertController()
        } else {
            SwAlert.dismissAlertView()
        }
    }
    
    // MARK: - UIAlertController (iOS 8 or later)
    
    private func showAlertController() {
        if AlertManager.sharedInstance.parentController.presentedViewController != nil {
           AlertManager.sharedInstance.alertQueue.append(self)
            return
        }
        
        var alertController = UIAlertController(title: self.title, message: self.message, preferredStyle: .Alert)
        
        for alertInfo in self.textFieldInfo {
            alertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = alertInfo.placeholder
                textField.text = alertInfo.title
            })
        }
        
        for alertInfo in self.otherButtonHandlers {
            var handler = alertInfo.completion
            let action = UIAlertAction(title: alertInfo.title, style: .Default, handler: { (action) -> Void in
                SwAlert.dismiss()
                if alertController.textFields?.count > 0 {
                    handler?(resultObject: alertController.textFields)
                } else {
                    handler?(resultObject: action)
                }
            })
            alertController.addAction(action)
        }
        
        if self.cancelInfo != nil {
            var handler = self.cancelInfo!.completion
            let action = UIAlertAction(title: self.cancelInfo!.title, style: .Cancel, handler: { (action) -> Void in
                SwAlert.dismiss()
                handler?(resultObject: action)
            })
            alertController.addAction(action)
        } else if self.otherButtonHandlers.count == 0 {
            if self.textFieldInfo.count > 0 {
                let action = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                    SwAlert.dismiss()
                })
                alertController.addAction(action)
            } else {
                let action = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    SwAlert.dismiss()
                })
                alertController.addAction(action)
            }
        }
        
        if AlertManager.sharedInstance.window.keyWindow == false {
            AlertManager.sharedInstance.window.alpha = 1.0
            AlertManager.sharedInstance.window.makeKeyAndVisible()
        }
        
        AlertManager.sharedInstance.parentController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private class func dismissAlertController() {
        if AlertManager.sharedInstance.alertQueue.count > 0 {
            let alert = AlertManager.sharedInstance.alertQueue[0]
            AlertManager.sharedInstance.alertQueue.removeAtIndex(0)
            alert.show()
        } else {
            AlertManager.sharedInstance.window.alpha = 0.0
            let mainWindow = UIApplication.sharedApplication().delegate?.window
            mainWindow!!.makeKeyAndVisible()
        }
    }
    
    // MARK: - UIAlertView (iOS 7)
    
    private func showAlertView() {
        if AlertManager.sharedInstance.showingAlertView != nil {
            AlertManager.sharedInstance.alertQueue.append(self)
            return
        }
        
        if self.cancelInfo == nil && self.textFieldInfo.count > 0 {
            self.cancelInfo = AlertInfo.generate("Cancel", placeholder: nil, completion: nil)
        }
        
        var cancelButtonTitle: String?
        if self.cancelInfo != nil {
            cancelButtonTitle = self.cancelInfo!.title
        }
        
        var alertView = UIAlertView(title: self.title, message: self.message, delegate: self, cancelButtonTitle: cancelButtonTitle)
        
        for alertInfo in self.otherButtonHandlers {
            alertView.addButtonWithTitle(alertInfo.title)
        }
        
        if self.textFieldInfo.count == 1 {
            alertView.alertViewStyle = .PlainTextInput
        } else if self.textFieldInfo.count == 2 {
            alertView.alertViewStyle = .LoginAndPasswordInput
        }
        
        AlertManager.sharedInstance.showingAlertView = self
        alertView.show()
    }
    
    private class func dismissAlertView() {
         AlertManager.sharedInstance.showingAlertView = nil
        
        if AlertManager.sharedInstance.alertQueue.count > 0 {
            let alert = AlertManager.sharedInstance.alertQueue[0]
            AlertManager.sharedInstance.alertQueue.removeAtIndex(0)
            alert.show()
        }
    }
    
    // MARK: - UIAlertViewDelegate
    
    // The field at index 0 will be the first text field (the single field or the login field), the field at index 1 will be the password field.
    
    public func alertViewShouldEnableFirstOtherButton(alertView: UIAlertView) -> Bool {
        if self.textFieldInfo.count > 0 {
            let textField = alertView.textFieldAtIndex(0)!
            let text = textField.text
            if text != nil && count(text) > 0 {
                return true
            }
        }
        return false
    }
    
    public func willPresentAlertView(alertView: UIAlertView) {
        if self.textFieldInfo.count > 0 {
            for index in 0..<self.textFieldInfo.count {
                var textField = alertView.textFieldAtIndex(index)
                if textField != nil {
                    let alertInfo = self.textFieldInfo[index]
                    textField!.placeholder = alertInfo.placeholder
                    textField!.text = alertInfo.title
                }
            }
        }
    }
    
    public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        var result : AnyObject? = alertView
        
        if self.textFieldInfo.count > 0 {
            var textFields : [UITextField] = []
            for index in 0..<self.textFieldInfo.count {
                var textField = alertView.textFieldAtIndex(index)
                if textField != nil {
                    textFields.append(textField!)
                }
            }
            result = textFields
        }
        
        if self.cancelInfo != nil && buttonIndex == alertView.cancelButtonIndex {
            self.cancelInfo!.completion?(resultObject: result)
        } else {
            var resultIndex = buttonIndex
            if self.textFieldInfo.count > 0 || self.cancelInfo != nil {
                resultIndex--
            }
            
            if self.otherButtonHandlers.count > resultIndex {
                let alertInfo = self.otherButtonHandlers[resultIndex]
                alertInfo.completion?(resultObject: result)
            }
        }
        
        SwAlert.dismiss()
    }
}

// MARK: - UIDevice Extension

public extension UIDevice {
    
    class func iosVersion() -> Float {
        let versionString =  UIDevice.currentDevice().systemVersion
        return NSString(string: versionString).floatValue
    }
    
    class func isiOS8orLater() ->Bool {
        let version = UIDevice.iosVersion()
        
        if version >= 8.0 {
            return true
        }
        return false
    }
}