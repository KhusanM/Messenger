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
    
    @IBOutlet weak var conteinerView: UIView!
    @IBOutlet weak var backGroundPhoto: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var timerView: TimerView!
    @IBOutlet weak var downloadImg: UIImageView!
    
    
    
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
        conteinerView.layer.cornerRadius = 20
        
        
        
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

        trailingConst = conteinerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        leadingConst = conteinerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        
        
        if with.isFistUser{
            conteinerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
            trailingConst.isActive = true
        }else{
            leadingConst.isActive = true
            conteinerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
        
        backGroundPhoto.image = with.image
        imgView.image = with.image
        backGroundPhoto.applyBlurEffect()
        
    }
    
    @IBAction func didSelectBtnTapped(_ sender: UIButton) {
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


