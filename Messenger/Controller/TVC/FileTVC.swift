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
    var trailingConst : NSLayoutConstraint!
    var leadingConst: NSLayoutConstraint!

    
    override func prepareForReuse() {
        super.prepareForReuse()
//        leadingConst.isActive = false
  //      trailingConst.isActive = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [ .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }

    
    
    
}
