//
//  profile.swift
//  WorkStoreViewer3
//
//  Created by Anthony Miller on 7/31/16.
//  Copyright © 2016 Anthony Miller. All rights reserved.
//

import Foundation
import UIKit


class Profile: NSObject, NSCoding {
    
    var image: UIImage!
    
    static let DocumentDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentDirectory.URLByAppendingPathComponent("profile")

    // MARK: Types
    struct PropertyKey {
        static let imageKey = "image"
    }
    
    init?(photo: UIImage) {
        self.image = photo
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(image, forKey: PropertyKey.imageKey)
    }
    
    required convenience init?(coder aDecoer: NSCoder) {
        let image = aDecoer.decodeObjectForKey(PropertyKey.imageKey) as! UIImage
        
        self.init(photo: image)
    }
    
}
