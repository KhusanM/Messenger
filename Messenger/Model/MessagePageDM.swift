//
//  MessagePageDM.swift
//  Messenger
//
//  Created by Kh's MacBook on 31.08.2021.
//

import UIKit
import RealmSwift

class MessagePageDM: Object {
    //message
    @objc dynamic var type: String?
    @objc dynamic var text: String?
    @objc dynamic var from_ID: Int = 0
    @objc dynamic var time: String?
    @objc dynamic var chat_ID: Int = 4
    //file
    @objc dynamic var fileName: String?
    @objc dynamic var fileURL: String?
    @objc dynamic var fileSize: String?
    //image
    @objc dynamic var imageURL: String?
    
    
    override class func primaryKey() -> String? {
        "time"
    }
}


