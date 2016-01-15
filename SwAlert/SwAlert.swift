//
//  SwAlert.swift
//  SwAlert
//
//  Created by xxxAIRINxxx on 2015/03/18.
//  Copyright (c) 2015 xxxAIRINxxx inc. All rights reserved.
//

import UIKit

public typealias CompletionHandler = (Result -> Void)

public enum AlertButtonType {
    case Cancel(title: String)
    case Other(title: String)
    case TextField(text: String, placeholder: String?)
}

extension AlertButtonType: Equatable { }

public func ==(lhs: AlertButtonType, rhs: AlertButtonType) -> Bool {
    switch (lhs, rhs) {
    case (.Cancel(let buttonTitleL), .Cancel(let buttonTitleR)):
        return buttonTitleL == buttonTitleR
    case (.Other(let buttonTitleL), .Other(let buttonTitleR)):
        return buttonTitleL == buttonTitleR
    case (.TextField(_, _), .TextField(_, _)):
        return true
    default:
        return false
    }
}

public enum Result {
    case Cancel
    case Other(inputText: [String])
}

private class AlertManager {
    
    static let sharedInstance = AlertManager()
    
    let window : UIWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
    
    var alertQueue : [SwAlert] = []
    var showingAlertView : SwAlert?
    
    lazy var parentController : UIViewController = {
        var parentController = UIViewController()
        parentController.view.backgroundColor = UIColor.clearColor()
        
        self.window.windowLevel = UIWindowLevelAlert
        self.window.rootViewController = parentController
        
        return parentController
    }()
}

private struct AlertInfo {
    
    let type : AlertButtonType
    let completion : CompletionHandler?
    
    init(type: AlertButtonType, completion: CompletionHandler?) {
        self.type = type
        self.completion = completion
    }
}

public final class SwAlert: NSObject, UIAlertViewDelegate {
    
    private let title : String
    private let message : String
    
    private var alertInfo : [AlertInfo] = []
    private var cancelInfo : AlertInfo?
    
    // MARK: - Static Functions
    
    public static func showNoActionAlert(title: String, message: String, buttonTitle: String) {
        let alert = SwAlert(title: title, message: message)
        alert.cancelInfo = AlertInfo(type: .Cancel(title: buttonTitle), completion: nil)
        alert.show()
    }
    
    public static func showOneActionAlert(title: String, message: String, buttonTitle: String, completion: CompletionHandler?) {
        let alert = SwAlert(title: title, message: message)
        alert.cancelInfo = AlertInfo(type: .Other(title: buttonTitle), completion: completion)
        alert.show()
    }
    
    // MARK: - Initializer
    
    public init(title: String?, message: String?) {
        self.title = title ?? ""
        self.message = message ?? ""
    }
    
    // MARK: - Instance Functions
    
    public func setCancelAction(buttonTitle: String, completion: CompletionHandler?) {
        self.cancelInfo = AlertInfo(type: .Cancel(title: buttonTitle), completion: completion)
    }
    
    public func addAction(buttonTitle: String, completion: CompletionHandler?) {
        let alertInfo = AlertInfo(type: .Other(title: buttonTitle), completion: completion)
        self.alertInfo.append(alertInfo)
    }
    
    public func addTextField(text: String, placeholder: String?) {
        let alertInfo = AlertInfo(type: .TextField(text: text, placeholder: placeholder), completion: nil)
        self.alertInfo.append(alertInfo)
    }
    
    public func show() {
        if #available(iOS 8.0, *) {
            self.showAlertController()
        } else {
            self.showAlertView()
        }
    }
    
    // MARK: - Private Functions
    
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
        
        if let _cancelInfo = self.cancelInfo {
            self.alertInfo.append(_cancelInfo)
            self.cancelInfo = nil
        }
        
        self.alertInfo.forEach() { info in
            switch info.type {
            case .Cancel(let buttonTitle):
                let action = UIAlertAction(title: buttonTitle, style: .Cancel, handler: { action in
                    SwAlert.dismiss()
                    
                    info.completion?(.Cancel)
                })
                alertController.addAction(action)
            case .Other(let buttonTitle):
                let action = UIAlertAction(title: buttonTitle, style: .Default, handler: { action in
                    SwAlert.dismiss()
                    
                    var inputText: [String] = []
                    alertController.textFields?.forEach() {
                        inputText.append($0.text ?? "")
                    }
                    info.completion?(.Other(inputText: inputText))
                })
                alertController.addAction(action)
            case .TextField(let text, let placeholder):
                alertController.addTextFieldWithConfigurationHandler({ textField in
                    textField.text = text
                    textField.placeholder = placeholder
                })
            }
        }
        
        if self.alertInfo.count == 0 {
            let action = UIAlertAction(title: "OK", style: .Default, handler: { action in
                SwAlert.dismiss()
            })
            alertController.addAction(action)
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
        
        var cancelButtonTitle: String = "Cancel"
        var otherButtonTitles: [String] = []
        var textFieldCount: Int = 0
        
        if let _cancelInfo = self.cancelInfo {
            switch _cancelInfo.type {
            case .Cancel(let buttonTitle):
                cancelButtonTitle = buttonTitle
            default:
                break
            }
        }
        
        self.alertInfo.forEach() { info in
            switch info.type {
            case .Cancel(_):
                break
            case .Other(let buttonTitle):
                otherButtonTitles.append(buttonTitle)
            case .TextField(_, _):
                textFieldCount++
            }
        }
        
        if self.cancelInfo == nil && self.alertInfo.count == 0 {
            UIAlertView(title: self.title, message: self.message, delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        let alertView = UIAlertView(title: self.title, message: self.message, delegate: self, cancelButtonTitle: cancelButtonTitle)
        
        otherButtonTitles.forEach() { buttonTitle in
            alertView.addButtonWithTitle(buttonTitle)
        }
        
        if textFieldCount == 1 {
            alertView.alertViewStyle = .PlainTextInput
        } else if textFieldCount == 2 {
            alertView.alertViewStyle = .LoginAndPasswordInput
        } else if textFieldCount >= 3 {
            assert(true, "iOS7 Alert textFields upper limit is 2")
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
        let textFieldInfo = self.alertInfo.filter() { $0.type == .TextField(text: "", placeholder: nil) }
        
        if textFieldInfo.count > 0 {
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
        let textFieldInfo = self.alertInfo.filter() { $0.type == .TextField(text: "", placeholder: nil) }
        
        for index in 0..<textFieldInfo.count {
            if let textField = alertView.textFieldAtIndex(index) {
                let info = textFieldInfo[index]
                switch info.type {
                case .TextField(let text, let placeholder):
                    textField.text = text
                    textField.placeholder = placeholder
                default:
                    break
                }
            }
        }
    }
    
    public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let textFieldInfo = self.alertInfo.filter() { $0.type == .TextField(text: "", placeholder: nil) }
        
        var inputText: [String] = []
        for index in 0..<textFieldInfo.count {
            if let textField = alertView.textFieldAtIndex(index) {
                inputText.append(textField.text ?? "")
            }
        }
        
        if buttonIndex == alertView.cancelButtonIndex {
            self.cancelInfo?.completion?(.Cancel)
        } else {
            var resultIndex = buttonIndex
            if textFieldInfo.count > 0 || self.cancelInfo != nil {
                resultIndex--
            }
            
            if self.alertInfo.count > resultIndex {
                let alertInfo = self.alertInfo[resultIndex]
                alertInfo.completion?(.Other(inputText: inputText))
            }
        }
        
        SwAlert.dismiss()
    }
}