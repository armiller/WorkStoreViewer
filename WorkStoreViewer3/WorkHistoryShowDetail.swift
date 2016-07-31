//
//  WorkHistoryShowDetail.swift
//  WorkStoreViewer3
//
//  Created by Anthony Miller on 7/30/16.
//  Copyright © 2016 Anthony Miller. All rights reserved.
//

import UIKit

class WorkHistoryShowDetail: UIViewController {

    var work: Work?
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let work = self.work {
            navigationItem.title = work.Company
            locationLabel.text = work.Location
            positionLabel.text = work.Position
            startDateLabel.text = work.StartDate
            endDateLabel.text = work.EndDate
            if work.Current != nil {
                currentLabel.text = "Yes"
            } else {
                currentLabel.text = "No"
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
