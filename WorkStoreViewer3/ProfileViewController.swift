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
    
    // MARK: Properties
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    var userdata: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.birthdayLabel.text = ""
        self.nameLabel.text = ""
        self.emailLabel.text = ""
        self.birthdayLabel.text = ""
        self.profile = loadProfile()
        if let profi = self.profile {
            self.profileImage.image = profi.image
        }
        
        let headers = ["Password": "testing"]
    	
        Alamofire.request(.GET, "https://cs496-assignment-4.appspot.com/user/armiller", headers: headers)
            .validate()
            .responseJSON { response in
                if let userdata = response.result.value as? NSDictionary {
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
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(p!, toFile: Profile.ArchiveURL.path!)
        
        if !isSuccessfulSave {
            print("Failed to save meals")
        }
    }
    
    func loadProfile() -> Profile? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Profile.ArchiveURL.path!) as? Profile
    }
    
    func setData() {
        self.userNameLabel.text = userdata!["Username"] as? String
        self.nameLabel.text = userdata!["Name"] as? String
        self.emailLabel.text = userdata!["Email"] as? String
        self.birthdayLabel.text = String(userdata!["Birthday"] as! Int)
        var skills = [String]()
        if let sk = userdata!["Skills"] as? NSArray {
            for item in sk {
                skills.append(item as! String)
            }
            self.skillsLabel.text = skills.joinWithSeparator(",")
        }
        var interests = [String]()
        if let it = userdata!["Interests"] as? NSArray {
            for item in it {
            	interests.append(item as! String)
            }
            self.interestsLabel.text = interests.joinWithSeparator(",")
        }
        if let bio = userdata!["Bio"] as? String {
            self.bioLabel.text = bio
        }
    }

    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
    	presentViewController(imagePickerController, animated: true, completion: nil)
    }
}

