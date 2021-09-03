//
//  Network.swift
//  PulBack
//
//  Created by Kh's MacBook on 19.08.2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import PKHUD


class Network{
    
    class func request(url: String, method: HTTPMethod, param: [String: Any]?, header: HTTPHeaders?, complition: @escaping (_ data: JSON?) -> ()){
        
        if Reachability.isConnectedToNetwork(){
            
            HUD.show(.progress)
            
            AF.request(url, method: method, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { response in
                HUD.hide()
                if let data = response.data{
                    complition(JSON(data))
                }else{
                    complition(nil)
                }
            }
        }else{
            print("No Internet")
            ShowAlert.showAlert(text: "No connection to internet", forState: .error)
        }
    }
    
    class func requestWithToken(url: String, method: HTTPMethod, param: [String: Any]?, complition: @escaping (_ data: JSON?) -> ()){
        
        if Reachability.isConnectedToNetwork(){
            let token = Keys.TOKEN
            let header: HTTPHeaders = [
                "Authorization" : "Bearer \(token)",
                "Content-Type" : "application/json"
                
            ]
            
            HUD.show(.progress)
            AF.request(AppData.base_chat_URL + url, method: method, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: { response in
                HUD.hide()
                if let data = response.data{
                    complition(JSON(data))
                }else{
                    complition(nil)
                }
            })
        }else{
            print("No Internet")
            ShowAlert.showAlert(text: "No connection to internet", forState: .error)
        }
    }
    
    
    class func uploadImage() {
        
    }

    

    
    
    
}
