//
//  FileTVC.swift
//  MessengerApp
//
//  Created by apple on 11/08/21.


import UIKit

class FileTVC: UITableViewCell {

    static var identifier = "FileTVC"
    static func unib()->UINib{
        return UINib(nibName: identifier, bundle: nil)
    }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var fileSizeLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var downloadImg: UIImageView!
    @IBOutlet weak var timerView: TimerView!
    @IBOutlet weak var fileView: UIView!
    @IBOutlet weak var fileImg: UIImageView!
    
    
    var trailingConst : NSLayoutConstraint!
    var leadingConst: NSLayoutConstraint!
    var index: IndexPath!
    var delegate: ChatDelegate?
    var didSelect = false
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leadingConst.isActive = false
        trailingConst.isActive = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 20
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectTapped))
        fileView.addGestureRecognizer(tapGesture)
        
    }
    
    func reloadView(){
        timerView.createCircularPath(radius: 30, lineWidth: 3, bgLineColor: .clear,progressColor: .gray, firstDuration: 3)
        timerView.progressAnimation()
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
    

    @objc func didSelectTapped(){
        if !didSelect{
            downloadImg.isHidden = true
            reloadView()
            didSelect = true
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                self.fileImg.isHidden = false
            }
        }else{
            delegate?.didSelectDocument(index: index)
        }
        
    }
    
}
