//
//  ImagePresentVC.swift
//  Messenger
//
//  Created by Kh's MacBook on 14.08.2021.
//

import UIKit

class ImagePresentVC: UIViewController {

    
    
    @IBOutlet weak var imgView: UIImageView!
    
    var img = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = img
        
    }


    

}
