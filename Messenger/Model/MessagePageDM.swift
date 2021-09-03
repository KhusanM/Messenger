//
//  MessagePageDM.swift
//  Messenger
//
//  Created by Kh's MacBook on 31.08.2021.
//

import UIKit

struct MessagePageDM {
    //message
    var type: String?
    var text: String?
    var from_ID: Int?
    var time: String?
    //file
    var fileName: String?
    var fileURL: URL?
    var fileSize: String?
    
    //image
    var imageURL: String?
    
    enum MediaType : String {
        case photo = "photo"
        case audio = "audio"
        case file = "document"
    }
}


