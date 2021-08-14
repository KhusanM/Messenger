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
    @IBOutlet weak var conteinerView: UIView!
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
        conteinerView.layer.cornerRadius = conteinerView.bounds.height * 0.15
        textLbl.textColor = .white
        timeLbl.textColor = .white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(message: MessageData){
        
        conteinerView.clipsToBounds = true
        trailingConst = conteinerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        leadingConst = conteinerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        textLbl.text = message.text
        
        
        if message.isFistUser{
            conteinerView.backgroundColor = .systemGreen //#colorLiteral(red: 0.8862745098, green: 0.9843137255, blue: 0.7882352941, alpha: 1)
            //timeLbl.textColor = #colorLiteral(red: 0.2078431373, green: 0.7803921569, blue: 0.2941176471, alpha: 1)
            conteinerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
            checkImg.isHidden = false
            trailingConst.isActive = true
            textLbl.textAlignment = .right
        }else{
            //timeLbl.textColor = .lightGray
            conteinerView.backgroundColor = .systemBlue
            checkImg.isHidden = true
            leadingConst.isActive = true
            conteinerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            textLbl.textAlignment = .left
        }
    }
    
    
    
}
