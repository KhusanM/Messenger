//
//  PhotoTVC.swift
//  Messenger
//
//  Created by Kh's MacBook on 11.08.2021.
//

import UIKit
import SDWebImage


class PhotoTVC: UITableViewCell {

    static let identifier = "PhotoTVC"
    static func unib() -> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backGroundPhoto: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var timerView: TimerView!
    @IBOutlet weak var downloadImg: UIImageView!
    @IBOutlet weak var realTimeLbl: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    
    
    
    var context = CIContext(options: nil)

    
    var trailingConst : NSLayoutConstraint!
    var leadingConst: NSLayoutConstraint!

    var delegate: ChatDelegate?
    var index : IndexPath!
    var didSelect = true
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leadingConst.isActive = false
        trailingConst.isActive = false
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        downloadImg.isHidden = true
        containerView.layer.cornerRadius = 20
        //imgView.applyBlurEffect()
        backGroundPhoto.applyBlurEffect()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectTapped))
        containerView.addGestureRecognizer(tapGesture)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

    func reloadView(){
        timerView.createCircularPath(radius: 30, lineWidth: 3, bgLineColor: .clear,progressColor: .white, firstDuration: 3)
        timerView.progressAnimation()
    }
    
    func updadeCell(message: MessagePageDM){

        trailingConst = containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        leadingConst = containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        realTimeLbl.text = GetDate.dateToString(date: message.time ?? "", format: "HH:mm")
        
        if message.from_ID == Keys.user_ID{
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
            trailingConst.isActive = true
        }else{
            leadingConst.isActive = true
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
        
        imgView.sd_setImage(with: URL(string: message.imageURL!), placeholderImage: UIImage(named: "loading"))
        backGroundPhoto.sd_setImage(with: URL(string: message.imageURL!))
        
    }
    
    @objc func didSelectTapped(){
        if !didSelect{
            downloadImg.isHidden = true
            //reloadView()
            didSelect = true
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                self.imgView.removeBlurEffect()
            }
        }else{
            delegate?.didSelectImage(index: index)
        }
    }
    
}


