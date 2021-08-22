//
//  PhotoTVC.swift
//  Messenger
//
//  Created by Kh's MacBook on 11.08.2021.
//

import UIKit



class PhotoTVC: UITableViewCell {

    
    static func unib() -> UINib{
        return UINib(nibName: "PhotoTVC", bundle: nil)
    }
    
    static let identifier = "PhotoTVC"
    
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
    var didSelect = false
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leadingConst.isActive = false
        trailingConst.isActive = false
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.applyBlurEffect()
        containerView.layer.cornerRadius = 20
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectTapped))
        containerView.addGestureRecognizer(tapGesture)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    func blurEffect() {
//
//        let currentFilter = CIFilter(name: "CIGaussianBlur")
//        let beginImage = CIImage(image: backGroundPhoto.image!)
//        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
//        currentFilter!.setValue(40, forKey: kCIInputRadiusKey)
//
//        let cropFilter = CIFilter(name: "CICrop")
//        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
//        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
//
//        let output = cropFilter!.outputImage
//        let cgimg = context.createCGImage(output!, from: output!.extent)
//        let processedImage = UIImage(cgImage: cgimg!)
//
//
//        backGroundPhoto.image = processedImage
//    }
    
    

    func reloadView(){
        timerView.createCircularPath(radius: 30, lineWidth: 3, bgLineColor: .clear,progressColor: .white, firstDuration: 3)
        timerView.progressAnimation()
    }
    
    func updadeCell(with: MessageData){

        trailingConst = containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        leadingConst = containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        
        
        if with.isFistUser{
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
            trailingConst.isActive = true
        }else{
            leadingConst.isActive = true
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
        
        backGroundPhoto.image = with.image
        imgView.image = with.image
        backGroundPhoto.applyBlurEffect()
        
    }
    
    @objc func didSelectTapped(){
        if !didSelect{
            downloadImg.isHidden = true
            reloadView()
            didSelect = true
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                self.imgView.removeBlurEffect()
            }
        }else{
            delegate?.didSelectImage(index: index)
        }
    }
    
}


