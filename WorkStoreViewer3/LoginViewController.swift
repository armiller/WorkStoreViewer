//
//  LoginViewController.swift
//  WorkStoreViewer3
//
//  Created by Anthony Miller on 8/11/16.
//  Copyright © 2016 Anthony Miller. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        loginButton.enabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    	let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        if !username.isEmpty && !password.isEmpty {
            loginButton.enabled = true
        }
        self.errorLabel.hidden = true
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginAction(sender: UIButton) {
        let headers = ["Password": passwordField.text!]
        let user = usernameField.text!
        
        Alamofire.request(.GET,
                          "https://cs496-assignment-4.appspot.com/user/\(user)",
            			  headers: headers)
                          .validate()
            		 	  .responseJSON { response in
                            switch response.result {
                            case .Success:
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.performSegueWithIdentifier("loginSegue", sender: sender)

                                })
                            case .Failure(let error):
                                if let status = error.userInfo["StatusCode"] as? Int {
                                    switch status {
                                    case 401:
                                            self.errorLabel.text = "Incorrect Password"
                                    case 404:
                                            self.errorLabel.text = "Invalid User"
                                    default:
                                            self.errorLabel.text = "System Error"

                                    }
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.errorLabel.hidden = false
                                    })
                                }
                        }
        }
        
    }
    
    @IBAction func unwindToLogin(sender: UIStoryboardSegue) {
        self.usernameField.text = ""
        self.passwordField.text = ""
        self.errorLabel.hidden = true
        self.loginButton.enabled = false
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender === loginButton {
        	let senderController = segue.destinationViewController as! ProfileViewController
            senderController.user = self.usernameField.text!
            senderController.password = self.passwordField.text!
        }
    }
}
