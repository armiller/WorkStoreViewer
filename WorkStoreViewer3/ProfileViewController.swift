//
//  ViewController.swift
//  WorkStoreViewer3
//
//  Created by Anthony Miller on 7/29/16.
//  Copyright © 2016 Anthony Miller. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var profile: Profile?
    var user: String?
    var password: String?
    
    // MARK: Properties
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var birthdayTitle: UILabel!
    @IBOutlet weak var skillsTitle: UILabel!
    @IBOutlet weak var InterestsTitle: UILabel!
    @IBOutlet weak var bioTitle: UILabel!
    
    var userdata: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.birthdayLabel.hidden = true
        self.nameLabel.text = ""
        self.emailLabel.text = ""
        self.bioTitle.hidden = true
        self.bioLabel.hidden = true
        self.birthdayTitle.hidden = true
        self.InterestsTitle.hidden = true
        self.interestsLabel.hidden = true
        self.skillsTitle.hidden = true
        self.skillsLabel.hidden = true
        
        
        self.profile = loadProfile()
        if let pro = self.profile {
            self.profileImage.image = pro.image
        }
        let headers = ["Password": self.password!]
        
        Alamofire.request(.GET, "https://cs496-assignment-4.appspot.com/user/\(user!)", headers: headers)
            .validate()
            .responseJSON { response in
                
                
                if let userdata = response.result.value as? NSDictionary {
                    print(userdata)
                    self.userdata = userdata
                    dispatch_async(dispatch_get_main_queue(), {
                        self.setData()
                    })
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImage.image = selectedImage
        saveProfile(selectedImage)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveProfile(image: UIImage) {
        let p = Profile(photo: image)
        print(self.user!)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(p!, toFile: Profile.DocumentDirectory.URLByAppendingPathComponent(self.user!).path!)
        
        if !isSuccessfulSave {
            print("Failed to save meals")
        }
    }
    
    func loadProfile() -> Profile? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Profile.DocumentDirectory.URLByAppendingPathComponent(self.user!).path!) as? Profile
    }
    
    func setData() {
        self.userNameLabel.text = userdata!["Username"] as? String
        self.nameLabel.text = userdata!["Name"] as? String
        self.emailLabel.text = userdata!["Email"] as? String
        if let birthday = userdata!["Birthday"] as? Int {
            if birthday != 0 {
                self.birthdayLabel.text = String(birthday)
                self.birthdayLabel.hidden = false
                self.birthdayTitle.hidden = false
            }
        }
        var skills = [String]()
        if let sk = userdata!["Skills"] as? NSArray {
            for item in sk {
                skills.append(item as! String)
            }
            self.skillsLabel.text = skills.joinWithSeparator(",")
            self.skillsLabel.hidden = false
            self.skillsTitle.hidden = false
        }
        var interests = [String]()
        if let it = userdata!["Interests"] as? NSArray {
            for item in it {
            	interests.append(item as! String)
            }
            self.interestsLabel.text = interests.joinWithSeparator(",")
            self.InterestsTitle.hidden = false
            self.interestsLabel.hidden = false
        }
        if let bio = userdata!["Bio"] as? String {
            if !bio.isEmpty {
                self.bioLabel.text = bio
                self.bioTitle.hidden = false
                self.bioLabel.hidden = false
            }
        }
    }

    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
    	presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender === self.navigationItem.rightBarButtonItem {
            let senderController = segue.destinationViewController as! WorkHistoryTable
            senderController.user = self.user!
            senderController.password = self.password!
        }
    }
    
//    @IBAction func unwindToProfile(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.sourceViewController as? LoginViewController {
//            let username = sourceViewController.usernameField.text!
//            let password = sourceViewController.passwordField.text!
//            self.user = username
//            self.password = password
//        }
//    }
}

