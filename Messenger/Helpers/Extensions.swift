//
//  Extensions.swift
//  Messenger
//
//  Created by Kh's MacBook on 17.08.2021.
//

import UIKit

// MARK: - Get File size
extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}


//MARK:- ImageView

extension UIImageView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}


//MARK:- Remove UIBlurEffect from UIView
extension UIView {
  

  func removeBlurEffect() {
    let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
    blurredEffectViews.forEach{ blurView in
      blurView.removeFromSuperview()
    }
  }
}


//MARK: - Date String to String

public class GetDate {
    
    
    class func dateToString(date: String,format: String) -> String {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter1.locale = Locale(identifier: "en_US_POSIX")
        
        if let date2 = formatter1.date(from: date) {
            let formatter2 = DateFormatter()
            formatter2.dateFormat = format
            formatter2.locale = Locale(identifier: "en_US_POSIX")
            let dateString = formatter2.string(from: date2)
            
            return dateString
        }
        return "Error"
        
    }
}




    
