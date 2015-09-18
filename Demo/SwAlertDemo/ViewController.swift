//
//  ViewController.swift
//  SwAlertDemo
//
//  Created by xxxAIRINxxx on 2015/05/13.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func noActionButtonAlert() {
        SwAlert.showNoActionAlert("no action title", message: "no action message", buttonTitle: "button title")
    }
    
    @IBAction func singleButtonAlert() {
        SwAlert.showOneActionAlert("one action title", message: "no action message", buttonTitle: "button title") { (resultObject) -> Void in
            print("showOneActionAlert completion")
        }
    }
    
    @IBAction func doubleButtonAlert() {
        let alert = SwAlert.generate("double action title", message: "double action message")
        alert.addAction("double action 1", completion: { resultObject in
            print("double action 1 completion")
        })
        alert.setCancelAction("cancel action", completion: { resultObject in
            print("cancel action completion")
        })
        alert.show()
    }
    
    @IBAction func tripleButtonAlert() {
        let alert = SwAlert.generate("triple action title", message: "triple action message")
        alert.addAction("triple action 1", completion: { resultObject in
            print("triple action 1 completion")
        })
        alert.addAction("triple action 2", completion: { resultObject in
            print("triple action 2 completion")
        })
        alert.setCancelAction("cancel action", completion: { resultObject in
            print("cancel action completion")
        })
        alert.show()
    }
    
    @IBAction func rollAlert() {
        for index in 0..<3 {
            let alert = SwAlert.generate("roll action" + String(index) + "title", message: "roll action" + String(index) + "message")
            alert.addAction("triple action" + String(index), completion: { resultObject in
                print("triple action" + String(index) + "completion")
            })
            alert.show()
        }
    }
    
    @IBAction func textAlert() {
        let alert = SwAlert.generate("text action title", message: "text action message")
        alert.addTextField("text action 1 title", placeholder: "text action 1 placeholder")
        alert.addTextField("text action 2 title", placeholder: "text action 2 placeholder")
        alert.addTextField("text action 3 title", placeholder: "text action 3 placeholder")
        alert.addAction("text action", completion: { (resultObject) -> Void in
            print("text action completion")
            print(resultObject)
        })
        
        alert.show()
    }
}

