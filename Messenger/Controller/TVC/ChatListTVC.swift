//
//  ChatListTVC.swift
//  Messenger
//
//  Created by Kh's MacBook on 30.08.2021.
//

import UIKit

class ChatListTVC: UITableViewCell {

    static let identifair = "ChatListTVC"
    static func unib() -> UINib {
        return UINib(nibName: identifair, bundle: nil)
    }
    
    @IBOutlet weak var firstLetterOfName: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var lastMessageLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateCell(user: UserDM, lastMessage: LastMessage){
        nameLbl.text = user.fullName
        lastMessageLbl.text = lastMessage.text
        timeLbl.text = lastMessage.time
        firstLetterOfName.text = String(user.fullName.prefix(1))
        
        let time = lastMessage.time
        
        //Time Handle
        guard let day = Int(GetDate.dateToString(date: time, format: "dd")) else { return print("ErrorDay") }
        guard let currentDay = Int(currentDateFormat(format: "dd")) else { return print("ErrorCurrentDay") }
        
        if GetDate.dateToString(date: time, format: "yyyy-MM-dd") == currentDateFormat(format: "yyyy-MM-dd") {
            timeLbl.text = GetDate.dateToString(date: time, format: "HH:mm")
            
        }else if GetDate.dateToString(date: time, format: "yyyy-MM") == currentDateFormat(format: "yyyy-MM") && abs(currentDay - day) <= 7 {
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            formatter1.locale = Locale(identifier: "en_US_POSIX")
            
            if let date2 = formatter1.date(from: time) {
                let weekday = Calendar.current.component(.weekday, from: date2 )
                var week = ""
                switch weekday {
                case 1: week = "Sun"
                case 2: week = "Mon"
                case 3: week = "Tue"
                case 4: week = "Wed"
                case 5: week = "Thu"
                case 6: week = "Fri"
                default:
                    week = "Sat"
                }
                timeLbl.text = week
            }
            
        }else {
            timeLbl.text = GetDate.dateToString(date: time, format: "MM/dd")  }
        
    }
    
    
    
    //Current Date Formatter
    func currentDateFormat(format: String) -> String {
        let currentTime = Date()
        let dayformatter = DateFormatter()
        dayformatter.dateFormat = format
       return  dayformatter.string(from: currentTime)
    }
}
