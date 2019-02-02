//
//  ViewController.swift
//  iMovie
//
//  Created by admin on 08/12/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let model: FireBaseModel = FireBaseModel.getInstance()
    
    @IBOutlet weak var Spinner: UIActivityIndicatorView!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Spinner.stopAnimating()
        self.Spinner.isHidden = true
    }

    @IBAction func login(_ sender: Any) {
        let email = self.EmailField.text
        let password = self.PasswordField.text
        if email != "" {
            if password != "" {
                self.Spinner.isHidden = false
                self.Spinner.startAnimating()
                model.signIn(email: email!, password: password!, callback: { (user) in
                    self.Spinner.stopAnimating()
                    self.Spinner.isHidden = true
                    if user != nil {
                        self.model.initRefs()
                        self.performSegue(withIdentifier: "loginSeg", sender: self)
                    } else {
                        self.openMessageBox(title: "Failed", message: "login failed")
                    }
                })
            } else {
                self.openMessageBox(title: "Empty password", message: "password can't be empty")
            }
        } else {
            self.openMessageBox(title: "Empty email", message: "email can't be empty")
        }
    }
    
    @IBAction func register(_ sender: Any) {
        let email = self.EmailField.text
        let password = self.PasswordField.text
        if email != "" {
            if password != "" {
                if password!.count < 6 {
                    self.openMessageBox(title: "Password too short", message: "has to be more than 6 characters")
                } else {
                    self.Spinner.isHidden = false
                    self.Spinner.startAnimating()
                    model.registerUser(email: email!, password: password!, callback: { (user) in
                        self.Spinner.stopAnimating()
                        self.Spinner.isHidden = true
                        if user != nil {
                            self.model.initRefs()
                            self.performSegue(withIdentifier: "loginSeg", sender: self)
                        } else {
                            self.openMessageBox(title: "Failed", message: "registaration failed")
                        }
                    })
                }
            } else {
                self.openMessageBox(title: "Empty password", message: "password can't be empty")
            }
        } else {
            self.openMessageBox(title: "Empty email", message: "email can't be empty")
        }
    }
    
    func openMessageBox(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

