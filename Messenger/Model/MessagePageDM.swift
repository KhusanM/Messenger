//
//  MessagePageDM.swift
//  Messenger
//
//  Created by Kh's MacBook on 31.08.2021.
//

import UIKit

struct MessagePageDM {
    var type: String
    var text: String
    var from_ID: Int
    var time: String
    
    enum MediaType : String {
        case photo = "photo"
        case audio = "audio"
        case file = "document"
    }
}


