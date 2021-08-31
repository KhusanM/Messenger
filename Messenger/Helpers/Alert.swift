//
//  Alert.swift
//  PulBack
//
//  Created by apple on 14/08/21.
//

import Foundation
import Alamofire
import UIKit
import SnapKit



enum AlertType {
        case warning
        case success
        case error
        case unknown
    }

class ShowAlert{
    
    class func showAlert(text: String,forState : AlertType,duration : TimeInterval = 4,userInteration : Bool = true){
        let alertView = UIView()
        alertView.frame = CGRect(x: 10, y: -80, width: UIScreen.main.bounds.width-20, height: 80)
        
        
        switch forState {
                    case .warning:
                        alertView.backgroundColor =  .red
                    case .error:
                        alertView.backgroundColor = .systemRed
                    case .success:
                        alertView.backgroundColor = .green
                    case .unknown:
                        alertView.backgroundColor = .yellow
        }
        alertView.layer.cornerRadius = 20
        alertView.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        alertView.layer.shadowRadius = 10
        alertView.layer.shadowOpacity = 0.7
        alertView.layer.shadowOffset = CGSize(width: 0, height: 5)
        alertView.tag = 2020
        let lbl = UILabel()
        alertView.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.edges.equalTo(alertView).inset(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
        }
        lbl.textAlignment = .center
        lbl.text = text
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 18)
        lbl.numberOfLines = 0
        

        if let window = UIApplication.shared.keyWindow{
            if window.viewWithTag(2020) == nil{
                window.addSubview(alertView)   
            }
        }
        
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseIn) {
            alertView.transform = CGAffineTransform(translationX: 0, y: (UIApplication.shared.statusBarFrame.height + 80))
        } completion: { _ in
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { time in

                UIView.animate(withDuration: 0.4) {
                    alertView.transform = .identity
                }completion: { _ in
                    alertView.removeFromSuperview()
                }
            }
        }
        
        let gesture = UISwipeGestureRecognizer()
        
        gesture.direction = .up
        gesture.addTarget(self, action: #selector(gestureFunc))
    }
    
    @objc class func gestureFunc(){
        if let view = UIApplication.shared.keyWindow?.viewWithTag(2020){
           
            UIView.animate(withDuration:0.4) {
                view.transform = .identity
            }completion: { _ in
                view .removeFromSuperview()
            }


        }
    }
}
