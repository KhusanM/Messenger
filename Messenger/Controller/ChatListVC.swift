//
//  ChatListVC.swift
//  Messenger
//
//  Created by Kh's MacBook on 30.08.2021.
//

import UIKit
import SwiftyJSON
import Alamofire


class ChatListVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.register(ChatListTVC.unib(), forCellReuseIdentifier: ChatListTVC.identifair)
        }
    }
    
    var chatListDM :[ChatPageDM] = []
    var user: UserDM!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Messages"
        
       getUserDM()
        if #available(iOS 13.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "circle"), style: .done, target: self, action: #selector(reload))
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func reload(){
        chatListDM.removeAll()
        getUserDM()
    }
    

    private func getUserDM(){
        Network.requestWithToken(url: "/chat/get-paging", method: .post, param: ["page" : 1, "limit": 10]) { data in
            if let data = data{
                for i in data["data"]["data"].arrayValue {
                    
                    if  i["second"]["user_id"].intValue != Keys.user_ID {
                        self.user = UserDM(fullName: i["second"]["full_name"].stringValue , user_ID:  i["second"]["user_id"].intValue, chat_ID: i["chat_id"].intValue )
                        
                    }else {
                        
                        self.user = UserDM(fullName: i["first"]["full_name"].stringValue , user_ID: i["first"]["user_id"].intValue, chat_ID: i["chat_id"].intValue )
                    }
                    
                    let lastMessage = LastMessage(text: i["last_message"]["text"].stringValue, type: i["last_message"]["type"].stringValue, time: i["last_message"]["created_at"].stringValue)
                    let dm = ChatPageDM(name: self.user, lastMessage: lastMessage)
                    
                    self.chatListDM.append(dm)
                    
                }
                self.tableView.reloadData()
                
                
            }
        }
    }
    

}

extension ChatListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.chatListDM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTVC.identifair, for: indexPath) as! ChatListTVC
        cell.updateCell(with: chatListDM[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = MessagesVC(nibName: "MessagesVC", bundle: nil)
        vc.title = chatListDM[indexPath.row].name.fullName
        vc.chatID = chatListDM[indexPath.row].name.chat_ID
        vc.userID = chatListDM[indexPath.row].name.user_ID
        navigationController?.pushViewController(vc, animated: true)
    }
}
