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
    
    var context = CIContext(options: nil)

    func blurEffect() {
        
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: backGroundPhoto.image!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(10, forKey: kCIInputRadiusKey)

        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")

        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        backGroundPhoto.image = processedImage
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        conteinerView.layer.cornerRadius = 20
        conteinerView.layer.maskedCorners = [ .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updadeCell(with: UIImage){
        backGroundPhoto.image = with
        imgView.image = with
        blurEffect()
    }
    
}
