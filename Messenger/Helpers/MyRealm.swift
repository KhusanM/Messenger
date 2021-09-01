//
//  MyRealm.swift
//  Foodie
//
//  Created by Kh's MacBook on 18.07.2021.
//

//import UIKit
//import RealmSwift
//
//class MyRealm {
//    static var shared = MyRealm()
//    var realm: Realm!
//
//    init() {
//        realm = try! Realm()
//        print(realm.configuration.fileURL ?? "")
//    }
//
//    func saveItems(item: MessagePageDM){
//        try! realm.write{
//            realm.add(item, update: .modified)
//        }
//    }
//
//    
////    func setCount(item: MessagePageDM, newCount: Int){
////        let arr = realm.objects(MessagePageDM.self).compactMap{$0}
////
////        for i in arr where i._id == item._id{
////            try! realm.write{
////                i.count = newCount
////            }
////        }
////    }
//
//    func fetchData() -> [MessagePageDM]{
//        realm.objects(MessagePageDM.self).compactMap{$0}
//    }
//
//    func deleteItem(item: MessagePageDM){
//        try! realm.write{
//            realm.delete(item)
//        }
//    }
//
//    func deleteAll(){
//        let a = realm.objects(MessagePageDM.self)
//        try! realm.write{
//            for i in a {
//                realm.delete(i)
//            }
//        }
//    }
//}
