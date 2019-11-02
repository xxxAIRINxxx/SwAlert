//
//  ViewController.swift
//  Demo
//
//  Created by xxxAIRINxxx on 2015/05/13.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit
import SwAlert

final class ViewController: UIViewController {

    @IBAction func noActionButtonAlert() {
        SwAlert.showAlert("no action title", message: "no action message", buttonTitle: "button title")
    }
    
    @IBAction func singleButtonAlert() {
        SwAlert.showAlert("one action title", message: "no action message", buttonTitle: "button title") { result in
            print("showOneActionAlert completion")
        }
    }
    
    @IBAction func doubleButtonAlert() {
        SwAlert(title: "double action title", message: "double action message")
            .addAction("double action 1") { result in
                print("double action 1 completion")
            }
            .setCancelAction("cancel action") { result in
                print("cancel action completion")
            }
            .show()
    }
    
    @IBAction func destructiveButtonAlert() {
        SwAlert(title: "destructive action title", message: "destructive action message")
            .addAction("triple action 1") { result in
                print("triple action 1 completion")
            }
            .addAction("triple action 2") { result in
                print("triple action 2 completion")
            }
            .addDestructiveAction("DESTROY!") { result in
                print("pressed DESTROY! button")
            }
            .setCancelAction("cancel action") { result in
                print("cancel triple action completion")
            }
            .show()
    }
    
    @IBAction func rollAlert() {
        for index in 0..<3 {
            SwAlert(title: "roll action " + String(index) + " title", message: "roll action " + String(index) + " message")
                .addAction("triple action" + String(index)) { result in
                    print("triple action " + String(index) + " completion")
                }
                .show()
        }
    }
    
    @IBAction func textAlert() {
        SwAlert(title: "text action title", message: "text action message")
            .addTextField("text action 1 title", placeholder: "text action 1 placeholder")
            .addTextField("text action 2 title", placeholder: "text action 2 placeholder")
            .addTextField("text action 3 title", placeholder: "text action 3 placeholder")
            .addAction("text action") { result in
                print("text action completion")
                print(result)
            }
            .show()
    }
}

