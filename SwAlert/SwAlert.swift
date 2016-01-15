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
    var alertQueue : [SwAlert] = []
    var showingAlertView : SwAlert?
    
    lazy var parentController : UIViewController = {
        var parentController = UIViewController()
        parentController.view.backgroundColor = UIColor.clearColor()
        
        if #available(iOS 8.0, *) {
            self.window.windowLevel = UIWindowLevelAlert
            self.window.rootViewController = parentController
        }
        
        return parentController
    }()
}

private class AlertInfo {
    var title : String = ""
    var placeholder : String = ""
    var completion : CompletionHandler?
    
    class func generate(title: String, placeholder: String?, completion: CompletionHandler?) -> AlertInfo {
        let alertInfo = AlertInfo()
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
    
    public static func showNoActionAlert(title: String, message: String, buttonTitle: String) {
        let alert = SwAlert()
        alert.title = title
        alert.message = message
        alert.cancelInfo = AlertInfo.generate(buttonTitle, placeholder: nil, completion: nil)
        alert.show()
    }
    
    public static func showOneActionAlert(title: String, message: String, buttonTitle: String, completion: CompletionHandler?) {
        let alert = SwAlert()
        alert.title = title
        alert.message = message
        alert.cancelInfo = AlertInfo.generate(buttonTitle, placeholder: nil, completion: completion)
        alert.show()
    }
    
    public static func generate(title: String, message: String) -> SwAlert {
        let alert = SwAlert()
        alert.title = title
        alert.message = message
        return alert
    }
    
    // MARK: - Instance Methods
    
    public func setCancelAction(buttonTitle: String, completion: CompletionHandler?) {
        self.cancelInfo = AlertInfo.generate(buttonTitle, placeholder: nil, completion: completion)
    }
    
    public func addAction(buttonTitle: String, completion: CompletionHandler?) {
        let alertInfo = AlertInfo.generate(buttonTitle, placeholder: nil, completion: completion)
        self.otherButtonHandlers.append(alertInfo)
    }
    
    public func addTextField(title: String, placeholder: String?) {
        let alertInfo = AlertInfo.generate(title, placeholder: placeholder, completion: nil)
        if #available(iOS 8.0, *) {
            self.textFieldInfo.append(alertInfo)
        } else {
            if self.textFieldInfo.count >= 2 {
                assert(true, "iOS7 Alert textFields upper limit is two")
            } else {
                self.textFieldInfo.append(alertInfo)
            }
        }
    }
    
    public func show() {
        if #available(iOS 8.0, *) {
            self.showAlertController()
        } else {
            self.showAlertView()
        }
    }
    
    // MARK: - Private Methods
    
    private static func dismiss() {
        if #available(iOS 8.0, *) {
            SwAlert.dismissAlertController()
        } else {
            SwAlert.dismissAlertView()
        }
    }
    
    // MARK: - UIAlertController (iOS 8 or later)
    
    @available(iOS 8.0, *)
    private func showAlertController() {
        if AlertManager.sharedInstance.window.keyWindow {
            AlertManager.sharedInstance.alertQueue.append(self)
            return
        } else {
            AlertManager.sharedInstance.window.alpha = 1.0
            AlertManager.sharedInstance.window.makeKeyAndVisible()
        }
        
        let alertController = UIAlertController(title: self.title, message: self.message, preferredStyle: .Alert)
        
        self.textFieldInfo.forEach() { info in
            alertController.addTextFieldWithConfigurationHandler({ textField -> Void  in
                textField.placeholder = info.placeholder
                textField.text = info.title
            })
        }
        
        self.otherButtonHandlers.forEach () {
            let handler = $0.completion
            let action = UIAlertAction(title: $0.title, style: .Default, handler: { (action) -> Void in
                SwAlert.dismiss()
                if alertController.textFields?.count > 0 {
                    handler?(resultObject: alertController.textFields)
                } else {
                    handler?(resultObject: action)
                }
            })
            alertController.addAction(action)
        }
        
        if let _cancelInfo = self.cancelInfo {
            let handler = _cancelInfo.completion
            let action = UIAlertAction(title: _cancelInfo.title, style: .Cancel, handler: { (action) -> Void in
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
        
        AlertManager.sharedInstance.parentController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @available(iOS 8.0, *)
    private static func dismissAlertController() {
        if AlertManager.sharedInstance.window.keyWindow {
            AlertManager.sharedInstance.window.alpha = 0.0
            if let _delegate = UIApplication.sharedApplication().delegate {
                if let _window = _delegate.window {
                    _window?.makeKeyAndVisible()
                }
            }
        }
        
        if AlertManager.sharedInstance.alertQueue.count > 0 {
            let alert = AlertManager.sharedInstance.alertQueue[0]
            AlertManager.sharedInstance.alertQueue.removeAtIndex(0)
            alert.show()
        }
    }
    
    // MARK: - UIAlertView (iOS 7)
    
    @available(iOS 7.0, *)
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
        
        let alertView = UIAlertView(title: self.title, message: self.message, delegate: self, cancelButtonTitle: cancelButtonTitle)
        
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
    
    private static func dismissAlertView() {
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
            if let textField = alertView.textFieldAtIndex(0) {
                switch textField.text {
                case nil : return false
                default : return true
                }
            }
        }
        return false
    }
    
    public func willPresentAlertView(alertView: UIAlertView) {
        for index in 0..<self.textFieldInfo.count {
            if let textField = alertView.textFieldAtIndex(index) {
                let alertInfo = self.textFieldInfo[index]
                textField.placeholder = alertInfo.placeholder
                textField.text = alertInfo.title
            }
        }
    }
    
    public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        var result : AnyObject? = alertView
        
        if self.textFieldInfo.count > 0 {
            var textFields : [UITextField] = []
            for index in 0..<self.textFieldInfo.count {
                let textField = alertView.textFieldAtIndex(index)
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