//
//  WorkHistory.swift
//  WorkStoreViewer3
//
//  Created by Anthony Miller on 7/29/16.
//  Copyright © 2016 Anthony Miller. All rights reserved.
//

import UIKit
import Alamofire

class WorkHistoryTable: UITableViewController, UINavigationControllerDelegate {

    var works = [Work]()
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
		get_works()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.works.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellidentifier = "WorkHistoryViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellidentifier, forIndexPath: indexPath) as! WorkHistoryTableViewCell

        let work = self.works[indexPath.row]
        // Configure the cell...
        cell.workLabel.text = work.Company

        return cell
    }
    
    func get_works() {
        var local_works = [Work]()
        let headers = ["Password": "testing"]
        
        Alamofire.request(.GET,
                          "https://cs496-assignment-4.appspot.com/work/armiller",
                          headers: headers)
            .validate()
            .responseJSON { response in
                if let items = response.result.value as? NSArray {
                    for item in items {
                        if let dic = item as? NSDictionary {
                            local_works.append(Work(data: dic))
                        }
                    }
                    self.works = local_works
                    dispatch_async(dispatch_get_main_queue(), {
                    	self.tableView.reloadData()
                    })
                }
        }
    }
    
    @IBAction func unwindToWorkList(sender: UIStoryboardSegue) {
        let headers = ["Password": "testing"]
        
        if let sourceViewController = sender.sourceViewController as? WorkHistoryView {
            // POST && PUT
            if let data = sourceViewController.rawData {
                if let work = sourceViewController.work {
                    Alamofire.request(.PUT,
                        "https://cs496-assignment-4.appspot.com/work/armiller/\(work.ID)",
                        parameters: data as? [String: AnyObject],
                        headers: headers, encoding: .JSON)
                        .validate()
                        .responseJSON { response in
                            let response_string = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                            print(response_string)
                            self.get_works()
                    }
                } else {
                    Alamofire.request(.POST, "https://cs496-assignment-4.appspot.com/work/armiller",
                        parameters: data as? [String : AnyObject],
                        headers: headers,
                        encoding: .JSON)
                        .responseJSON { response in
                            let response_string = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                            print(response_string)
                            self.get_works()
                    }
                }
            }

         
            if sourceViewController.delete {
                let id = sourceViewController.work!.ID
                Alamofire.request(.DELETE,
                    "https://cs496-assignment-4.appspot.com/work/armiller/\(id)",
                    headers: headers,
                    encoding: .JSON)
                    .validate()
                    .responseJSON { response in
                        let response_string = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                        print(response_string)
                        self.get_works()
                }
            }
    	}
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDetail" {
            let workDetailController = segue.destinationViewController as! WorkHistoryView
            
            if let selectedWorkCell = sender as? WorkHistoryTableViewCell {
                let indexPath = self.tableView.indexPathForCell(selectedWorkCell)!
                let selectedWork = works[indexPath.row]
                workDetailController.work = selectedWork
            }
            
        } else if segue.identifier == "AddItem" {
            print("Adding new meal.")
        }
    }

}
