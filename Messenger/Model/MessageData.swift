//
//  MessageData.swift
//  Messenger
//
//  Created by Kh's MacBook on 26.08.2021.
//

import UIKit



protocol ChatDelegate {
    func didSelectImage(index: IndexPath)
    func didSelectDocument(index: IndexPath)
}

struct MessageData {
    
    enum MediaType : String {
        case photo = "Photo"
        case audio = "Audio"
        case file = "File"
    }
    
    var text: String?
    var isFistUser: Bool
    
    var image: UIImage?
    var imageHeight : Int?
    var imageWidth : Int?
    
    var documentName: String?
    var documentURL: URL?
    var documentSize: String?
    var mediaType: MediaType?
    
    var audiFiles: String?
    
}


