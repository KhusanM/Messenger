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
    
    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textLbl: UILabel!
    
    
    
    var trailingConst : NSLayoutConstraint!
    var leadingConst: NSLayoutConstraint!

    
    override func prepareForReuse() {
        super.prepareForReuse()
        leadingConst.isActive = false
        trailingConst.isActive = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = containerView.bounds.height * 0.15
        textLbl.textColor = .white
        timeLbl.textColor = .white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(message: MessageData){
        
        containerView.clipsToBounds = true
        trailingConst = containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        leadingConst = containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        textLbl.text = message.text
        
        
        if message.isFistUser{
            containerView.backgroundColor = .systemGreen
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
            checkImg.isHidden = false
            trailingConst.isActive = true
            textLbl.textAlignment = .right
        }else{
            
            containerView.backgroundColor = .systemBlue
            checkImg.isHidden = true
            leadingConst.isActive = true
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            textLbl.textAlignment = .left
        }
    }
    
    
    
}
