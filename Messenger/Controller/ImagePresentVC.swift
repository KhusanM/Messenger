//
//  ImagePresentVC.swift
//  Messenger
//
//  Created by Kh's MacBook on 14.08.2021.
//

import UIKit

class ImagePresentVC: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    var img = UIImage()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = img
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.zoomScale = 1
        scrollView.bouncesZoom = false
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        
        doubleTap()
        shareBtn()
        
    }
    
    private func doubleTap(){
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGest)
    }
    
    private func shareBtn(){
        if #available(iOS 13.0, *) {
            let shareBtn = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareBtnTapped))
            navigationItem.rightBarButtonItem = shareBtn

        } else {
            // Fallback on earlier versions
        }
        
        }
    
    @objc func shareBtnTapped() {
        
        let data = [img] as [Any]
        let vc = UIActivityViewController(activityItems: data, applicationActivities: nil)
        
        present(vc, animated: true, completion: nil)
    }

    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        }
        else {
            scrollView.setZoomScale(1, animated: true)
        }
    }

    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imgView.frame.size.height / scale
        zoomRect.size.width  = imgView.frame.size.width  / scale
        let newCenter = imgView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    

}

extension ImagePresentVC: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    
}
