//
//  Cache.swift
//  PulBack
//
//  Created by Kh's MacBook on 19.08.2021.
//

import UIKit

class Cache {
    
//    static func saveUser(user: UserDM){
//        let encode = JSONEncoder()
//        if let data = try? encode.encode(user){
//            UserDefaults.standard.setValue(data, forKey: Keys.user_info)
//        }
//    }
//    
//    static func getUser() -> UserDM?{
//        let decoder = JSONDecoder()
//        if let data = UserDefaults.standard.object(forKey: Keys.user_info) as? Data{
//            if let decoderData = try? decoder.decode(UserDM.self, from: data){
//                
//                return decoderData
//            }
//        }
//        
//        return nil
//    }
    
    class func saveUserToken(token:String?){
        UserDefaults.standard.setValue(token, forKey: Keys.TOKEN)
    }
    
    class func getUserToken() -> String{
        return UserDefaults.standard.string(forKey: Keys.TOKEN)!
    }
    
}
