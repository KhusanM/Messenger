//
//  MessageTVC.swift
//  Messenger
//
//  Created by Kh's MacBook on 11.08.2021.
//

import UIKit

class MessageTVC: UITableViewCell {

    static func unib() -> UINib{
        return UINib(nibName: "MessageTVC", bundle: nil)
    }
    
    static let identifier = "MessageTVC"
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightTextLbl: UILabel!
    
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftTextLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        rightView.layer.cornerRadius = rightView.bounds.height * 0.15
        rightView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
        leftView.layer.cornerRadius = leftView.bounds.height * 0.15
        leftView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func rightLbl(with: String){
        rightTextLbl.text = with
    }
    
    func leftLbl(with: String){
        leftTextLbl.text = with
    }
    
    
}
