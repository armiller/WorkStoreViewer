//
//  WorkHistoryView.swift
//  WorkStoreViewer3
//
//  Created by Anthony Miller on 7/30/16.
//  Copyright © 2016 Anthony Miller. All rights reserved.
//

import UIKit
import Alamofire

class WorkHistoryView: UIViewController, UITextFieldDelegate {
    
    var work: Work?
    var rawData: NSDictionary?
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var companyfield: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var positionField: UITextField!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var currentField: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
		
        companyfield.delegate = self
        locationField.delegate = self
        positionField.delegate = self
        startDateField.delegate = self
        endDateField.delegate = self
        // Do any additional setup after loading the view.
        checkValidWorkHistory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        saveButton.enabled = false
        if textField === companyfield {
            navigationItem.title = companyfield.text
        }
        checkValidWorkHistory()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func checkValidWorkHistory() {
    	let nametext = companyfield.text ?? ""
        let locationtext = locationField.text ?? ""
        let positiontext = positionField.text ?? ""
        let starttext = startDateField.text ?? ""
        
        if !nametext.isEmpty && !locationtext.isEmpty && !positiontext.isEmpty && !starttext.isEmpty {
            saveButton.enabled = true
        } else {
            saveButton.enabled = false
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
    	companyfield.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let workdata:NSDictionary = [
                "Company" : self.companyfield.text!,
                "Location" : self.locationField.text!,
                "Position" : self.positionField.text!,
                "StartDate" : self.startDateField.text!,
                "EndDate" : self.endDateField.text!,
                "Current" : self.currentField.on
            ]
            self.rawData = workdata
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
