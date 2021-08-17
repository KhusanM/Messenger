//
//  FileTVC.swift
//  MessengerApp
//
//  Created by apple on 11/08/21.


import UIKit

class FileTVC: UITableViewCell {

    static var identifier = "FileTVC"
    static func unib()->UINib{
        return UINib(nibName: "FileTVC", bundle: nil)
    }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var fileSizeLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    var trailingConst : NSLayoutConstraint!
    var leadingConst: NSLayoutConstraint!
    var index: IndexPath!
    var delegate: ChatDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leadingConst.isActive = false
        trailingConst.isActive = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 20
        //containerView.layer.maskedCorners = [ .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }

    
    func updateCell(file: MessageData){
        
        trailingConst = containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        leadingConst = containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        
        
        if file.isFistUser{
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
            trailingConst.isActive = true
        }else{
            leadingConst.isActive = true
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
        
        
        fileNameLbl.text = file.documentName
        fileSizeLbl.text = file.documentSize
    }
    
    @IBAction func fileBtnTapped(_ sender: Any) {
        delegate?.didSelectDocument(index: index)
        
    }
    
    
}
