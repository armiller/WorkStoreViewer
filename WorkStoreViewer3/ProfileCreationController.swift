//
//  ProfileCreationController.swift
//  WorkStoreViewer3
//
//  Created by Anthony Miller on 8/12/16.
//  Copyright © 2016 Anthony Miller. All rights reserved.
//

import UIKit
import Alamofire

class ProfileCreationController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.hidden = true
        
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        nameField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        emailField.delegate = self
        
        validateInput()
        // Do any additional setup after loading the view.
    }
    
    
    func validateInput() {
        let user = usernameField.text ?? ""
        let pass = passwordField.text ?? ""
        let name = nameField.text ?? ""
        let email = emailField.text ?? ""
        
        if !user.isEmpty && !pass.isEmpty && !name.isEmpty && !email.isEmpty {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        validateInput()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func saveAccount(sender: UIBarButtonItem) {
        let data:NSDictionary = [
        	"Name": nameField.text!,
            "Username": usernameField.text!,
            "Password": passwordField.text!,
            "Email": emailField.text!
        ]
        
        Alamofire.request(.POST, "https://cs496-assignment-4.appspot.com/user",
                          parameters: data as? [String: AnyObject],
                          encoding: .JSON)
        				 .validate()
            .responseJSON { response in
                let response_string = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                print(response_string)

                
                switch response.result {
                case .Success:
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("newProfile", sender: sender)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender === self.navigationItem.rightBarButtonItem {
            let senderController = segue.destinationViewController as! ProfileViewController
            senderController.user = self.usernameField.text!
            senderController.password = self.passwordField.text!
            print("Preparing!")
        }
    }

}
