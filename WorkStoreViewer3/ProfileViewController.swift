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
    
    // MARK: Properties
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var userdata: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.birthdayLabel.text = ""
        self.nameLabel.text = ""
        self.emailLabel.text = ""
        self.birthdayLabel.text = ""
    	
        Alamofire.request(.GET, "https://cs496-assignment-4.appspot.com/user/armiller")
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
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setData() {
        self.userNameLabel.text = userdata!["Username"] as? String
        self.nameLabel.text = userdata!["Name"] as? String
        self.emailLabel.text = userdata!["Email"] as? String
        self.birthdayLabel.text = String(userdata!["Birthday"] as! Int)
    }

    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
    	presentViewController(imagePickerController, animated: true, completion: nil)
    }
}

