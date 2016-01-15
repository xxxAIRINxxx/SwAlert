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
        SwAlert.showOneActionAlert("one action title", message: "no action message", buttonTitle: "button title") { result in
            print("showOneActionAlert completion")
        }
    }
    
    @IBAction func doubleButtonAlert() {
        let alert = SwAlert(title: "double action title", message: "double action message")
        alert.addAction("double action 1", completion: { result in
            print("double action 1 completion")
        })
        alert.setCancelAction("cancel action", completion: { result in
            print("cancel action completion")
        })
        alert.show()
    }
    
    @IBAction func tripleButtonAlert() {
        let alert = SwAlert(title: "triple action title", message: "triple action message")
        alert.addAction("triple action 1", completion: { result in
            print("triple action 1 completion")
        })
        alert.addAction("triple action 2", completion: { result in
            print("triple action 2 completion")
        })
        alert.setCancelAction("cancel action", completion: { result in
            print("cancel triple action completion")
        })
        alert.show()
    }
    
    @IBAction func rollAlert() {
        for index in 0..<3 {
            let alert = SwAlert(title: "roll action " + String(index) + " title", message: "roll action " + String(index) + " message")
            alert.addAction("triple action" + String(index), completion: { result in
                print("triple action " + String(index) + " completion")
            })
            alert.show()
        }
    }
    
    @IBAction func textAlert() {
        let alert = SwAlert(title: "text action title", message: "text action message")
        alert.addTextField("text action 1 title", placeholder: "text action 1 placeholder")
        alert.addTextField("text action 2 title", placeholder: "text action 2 placeholder")
        alert.addTextField("text action 3 title", placeholder: "text action 3 placeholder")
        alert.addAction("text action", completion: { result in
            print("text action completion")
            print(result)
        })
        
        alert.show()
    }
}

