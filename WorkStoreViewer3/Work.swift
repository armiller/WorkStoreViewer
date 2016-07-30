//
//  Work.swift
//  WorkStoreViewer3
//
//  Created by Anthony Miller on 7/30/16.
//  Copyright © 2016 Anthony Miller. All rights reserved.
//

import Foundation

class Work {
    
    var ID: Int!
    var Company: String!
    var Location: String!
    var Position: String!
    var StartDate: String!
    var EndDate: String?
    var Current: Bool?
    var Description: String?
    var ReasonLeave: String?
    var ManagerName: String?
    var ManagerEmail: String?
    var ManagerPhone: String?
    
    
    init(data: NSDictionary) {
        self.parse(data)
    }
    
    func parse(data: NSDictionary) {
        self.ID = data["ID"] as! Int
        self.Company = data["Company"] as! String
        self.Location = data["Location"] as! String
        self.Position = data["Position"] as! String
        self.StartDate = data["StartDate"] as! String
        self.EndDate = data["EndDate"] as? String
        self.Current = data["Current"] as? Bool
        self.Description = data["Description"] as? String
        self.ReasonLeave = data["ReasonLeave"] as? String
        self.ManagerName = data["ManagerName"] as? String
        self.ManagerEmail = data["ManagerEmail"] as? String
        self.ManagerPhone = data["ManagerPhone"] as? String
    }
}
