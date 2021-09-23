//
//  ChatListVC.swift
//  Messenger
//
//  Created by Kh's MacBook on 30.08.2021.
//

import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

class ChatListVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.register(ChatListTVC.unib(), forCellReuseIdentifier: ChatListTVC.identifair)
        }
    }
    
    var user: [UserDM] = []
    var lastMessage: [LastMessage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
         
        if Reachability.isConnectedToNetwork() {
            getUserDM()
        } else {
            fetchData()
        }
        
        if #available(iOS 13.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "circle"), style: .done, target: self, action: #selector(reload))
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @objc func reload(){
        getUserDM()
    }
    

    private func getUserDM(){
        Network.requestWithToken(url: "/chat/get-paging", method: .post, param: ["page" : 1, "limit": 10]) { data in
            if let data = data{
                
                self.user.removeAll()
                self.lastMessage.removeAll()
                
                for i in data["data"]["data"].arrayValue {
                    
                    if  i["second"]["user_id"].intValue != Keys.user_ID {
                        let user2 = UserDM()
                        user2.chat_ID = i["chat_id"].intValue
                        user2.fullName = i["second"]["full_name"].stringValue
                        user2.user_ID = i["second"]["user_id"].intValue
                        self.user.append(user2)
                    }else {
                        let user1 = UserDM()
                        user1.chat_ID = i["chat_id"].intValue
                        user1.fullName = i["first"]["full_name"].stringValue
                        user1.user_ID = i["first"]["user_id"].intValue
                        self.user.append(user1)
                    }
                    
                    let lastM = LastMessage()
                    lastM.text = i["last_message"]["text"].stringValue
                    lastM.type = i["last_message"]["type"].stringValue
                    lastM.time = i["last_message"]["created_at"].stringValue
                    lastM._id = i["last_message"]["_id"].stringValue
                    
                    self.lastMessage.append(lastM)
                }
                
                self.tableView.reloadData()
                
                MyRealm.shared.saveItemsUser(item: self.user)
                MyRealm.shared.saveItemsLastM(item: self.lastMessage)
            }
        }
    }
    
    func fetchData(){
        user = MyRealm.shared.fetchUserData()
        lastMessage = MyRealm.shared.fetchLastMessageData()
        tableView.reloadData()
    }
    

}

extension ChatListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTVC.identifair, for: indexPath) as! ChatListTVC
        cell.updateCell(user: user[indexPath.row], lastMessage: lastMessage[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = MessagesVC(nibName: "MessagesVC", bundle: nil)
        vc.title = user[indexPath.row].fullName
        vc.chatID = user[indexPath.row].chat_ID
        vc.userID = user[indexPath.row].user_ID
        navigationController?.pushViewController(vc, animated: true)
    }
}
