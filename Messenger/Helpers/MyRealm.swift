//
//  MyRealm.swift
//  Foodie
//
//  Created by Kh's MacBook on 18.07.2021.
//

import UIKit
import RealmSwift

class MyRealm {
    static var shared = MyRealm()
    var realm: Realm!
    
    init() {
        realm = try! Realm()
        print(realm.configuration.fileURL ?? "")
    }
    
    func saveItemsUser(item: [UserDM]){
        try! realm.write{
            realm.add(item, update: .modified)
        }
    }
    func saveItemsLastM(item: [LastMessage]){
        try! realm.write{
            realm.add(item, update: .modified)
        }
    }
    
    func saveItemsMessage(item: [MessagePageDM]){
        try! realm.write{
            realm.add(item, update: .modified)
        }
    }
    
//    func setCount(item: ItemDM, newCount: Int){
//        let arr = realm.objects(ItemDM.self).compactMap{$0}
//
//        for i in arr where i._id == item._id{
//            try! realm.write{
//                i.count = newCount
//            }
//        }
//    }
    
    func fetchUserData() -> [UserDM]{
        realm.objects(UserDM.self).compactMap{$0}
    }
    
    func fetchLastMessageData() -> [LastMessage]{
        realm.objects(LastMessage.self).compactMap{$0}
    }
    
//    func fetchMessagePageDM() -> [MessagePageDM]{
//        realm.objects(MessagePageDM.self).compactMap{$0}
//    }
    
    func fetchMessagePageDM(in id: Int, for date: Date) -> [MessagePageDM] {
       
        realm.objects(MessagePageDM.self).sorted(byKeyPath: "time", ascending: true).filter { (message) -> Bool in
            
            return (message.chat_ID == id) && (String(message.time!.prefix(10)) == String(date.description.prefix(10)))
        }
        
    }
    
//    func deleteItem(item: ItemDM){
//        try! realm.write{
//            realm.delete(item)
//        }
//    }
//
//    func deleteAll(){
//        let a = realm.objects(ItemDM.self)
//        try! realm.write{
//            for i in a {
//                realm.delete(i)
//            }
//        }
//    }
}
