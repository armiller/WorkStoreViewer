//
//  ViewController.swift
//  WorkStoreViewer3
//
//  Created by Anthony Miller on 7/29/16.
//  Copyright © 2016 Anthony Miller. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UITableViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
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
    
    func setData() {
        self.userNameLabel.text = userdata!["Username"] as? String
        self.nameLabel.text = userdata!["Name"] as? String
        self.emailLabel.text = userdata!["Email"] as? String
        self.birthdayLabel.text = String(userdata!["Birthday"] as! Int)
    }

}

