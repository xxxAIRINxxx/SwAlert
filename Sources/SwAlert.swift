//
//  SwAlert.swift
//  SwAlert
//
//  Created by xxxAIRINxxx on 2015/03/18.
//  Copyright (c) 2015 xxxAIRINxxx inc. All rights reserved.
//

import UIKit

public struct SwAlertSettings {
    
    private init() {}
    
    static var defaultButtonTitle: String = "OK"
}

public typealias CompletionHandler = ((SwAlertResult) -> Void)

public enum AlertButtonType {
    case cancel(title: String)
    case other(title: String)
    case destructive(title: String)
    case textField(text: String, placeholder: String?)
}

public enum SwAlertResult {
    case cancel
    case other(inputText: [String])
}

private final class AlertManager {
    
    static let sharedInstance = AlertManager()
    
    let window : UIWindow = UIWindow(frame: UIScreen.main.bounds)
    
    var alertQueue : [SwAlert] = []
    var showingAlertView : SwAlert?
    
    lazy var parentController : UIViewController = {
        var parentController = UIViewController()
        parentController.view.backgroundColor = UIColor.clear
        
        self.window.windowLevel = UIWindow.Level.alert
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
    
    fileprivate let title : String
    fileprivate let message : String
    
    fileprivate var alertInfo : [AlertInfo] = []
    fileprivate var cancelInfo : AlertInfo?
    
    // MARK: - Static Functions
    
    public static func showAlert(_ title: String?, message: String?, buttonTitle: String, _ completion: CompletionHandler? = nil) {
        let alert = SwAlert(title: title, message: message)
        alert.cancelInfo = AlertInfo(type: .cancel(title: buttonTitle), completion: completion)
        alert.show()
    }
    
    
  
    
    // MARK: - Initializer
    
    public init(title: String?, message: String?) {
        self.title = title ?? ""
        self.message = message ?? ""
    }
    
    // MARK: - Instance Functions
    
    public func setCancelAction(_ buttonTitle: String, _ completion: CompletionHandler? = nil) -> SwAlert {
        self.cancelInfo = AlertInfo(type: .cancel(title: buttonTitle), completion: completion)
        return self
    }
    
    public func addAction(_ buttonTitle: String, _ completion: CompletionHandler? = nil) -> SwAlert {
        let alertInfo = AlertInfo(type: .other(title: buttonTitle), completion: completion)
        self.alertInfo.append(alertInfo)
        return self
    }
    
    public func addDestructiveAction(_ buttonTitle: String, _ completion: CompletionHandler? = nil) -> SwAlert {
      let alertInfo = AlertInfo(type: .destructive(title: buttonTitle), completion: completion)
      self.alertInfo.append(alertInfo)
      return self
    }
    
    public func addTextField(_ text: String, placeholder: String? = nil) -> SwAlert {
        let alertInfo = AlertInfo(type: .textField(text: text, placeholder: placeholder), completion: nil)
        self.alertInfo.append(alertInfo)
        return self
    }
    
    public func show() {
        self.showAlertController(.alert)
    }
    
    public func showAsActionSheet() {
        self.showAlertController(.actionSheet)
    }
    
    // MARK: - Private Functions
    
    fileprivate static func dismiss() {
        SwAlert.dismissAlertController()
    }
}

extension SwAlert {
    
    fileprivate func showAlertController(_ preferred_style:UIAlertController.Style) {
        if AlertManager.sharedInstance.window.isKeyWindow {
            AlertManager.sharedInstance.alertQueue.append(self)
            return
        } else {
            AlertManager.sharedInstance.window.alpha = 1.0
            AlertManager.sharedInstance.window.makeKeyAndVisible()
        }
        
        var alertController = UIAlertController(title: self.title == "" ? nil : self.title, message: self.message == "" ? nil : self.message, preferredStyle: preferred_style)
        
        // for ipad, override the actionSheet style
        if let popoverController = alertController.popoverPresentationController {
            alertController = UIAlertController(title: self.title == "" ? nil : self.title, message: self.message == "" ? nil : self.message, preferredStyle: .alert)
        }
        
        
        if let _cancelInfo = self.cancelInfo {
            self.alertInfo.append(_cancelInfo)
            self.cancelInfo = nil
        }
        
        self.alertInfo.forEach() { info in
            switch info.type {
            case .cancel(let buttonTitle):
                let action = UIAlertAction(title: buttonTitle, style: .cancel, handler: { action in
                    SwAlert.dismiss()
                    
                    info.completion?(.cancel)
                })
                alertController.addAction(action)
            case .other(let buttonTitle):
                let action = UIAlertAction(title: buttonTitle, style: .default, handler: { action in
                    SwAlert.dismiss()
                    
                    var inputText: [String] = []
                    alertController.textFields?.forEach() {
                        inputText.append($0.text ?? "")
                    }
                    info.completion?(.other(inputText: inputText))
                })
                alertController.addAction(action)
            case .destructive(let buttonTitle):
                let action = UIAlertAction(title: buttonTitle, style: .destructive, handler: { action in
                    SwAlert.dismiss()
                    
                    var inputText: [String] = []
                    alertController.textFields?.forEach() {
                        inputText.append($0.text ?? "")
                    }
                    info.completion?(.other(inputText: inputText))
                })
                alertController.addAction(action)
            case .textField(let text, let placeholder):
                alertController.addTextField(configurationHandler: { textField in
                    textField.text = text
                    textField.keyboardType = .numbersAndPunctuation
                    textField.enablesReturnKeyAutomatically = false
                    textField.placeholder = placeholder
                    if UITraitCollection.current.userInterfaceStyle == .dark {
                        textField.keyboardAppearance = .dark
                    }
                })
            }
        }
        
        if self.alertInfo.count == 0 {
            let action = UIAlertAction(title: SwAlertSettings.defaultButtonTitle, style: .default, handler: { action in
                SwAlert.dismiss()
            })
            alertController.addAction(action)
        }
        
        
        
        AlertManager.sharedInstance.parentController.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate static func dismissAlertController() {
        AlertManager.sharedInstance.window.alpha = 0.0
        if let _delegate = UIApplication.shared.delegate {
            if let _window = _delegate.window {
                _window?.makeKeyAndVisible()
            }
        }
        
        if AlertManager.sharedInstance.alertQueue.count > 0 {
            let alert = AlertManager.sharedInstance.alertQueue[0]
            AlertManager.sharedInstance.alertQueue.remove(at: 0)
            alert.show()
        }
    }
}
