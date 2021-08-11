//
//  MainVC.swift
//  Messenger
//
//  Created by Kh's MacBook on 10.08.2021.
//

import UIKit
import MobileCoreServices


struct ChatDM {
    var message: String?
    var img: UIImage?
}


class MainVC: UIViewController {

    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 45, right: 0)
            tableView.register(MessageTVC.unib(), forCellReuseIdentifier: MessageTVC.identifier)
            tableView.register(PhotoTVC.unib(), forCellReuseIdentifier: PhotoTVC.identifier)
            tableView.register(FileTVC.unib(), forCellReuseIdentifier: FileTVC.identifier)
        }
    }
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.delegate = self
            textView.layer.cornerRadius = 17
            textView.layer.borderWidth = 1
            textView.layer.borderColor = UIColor.systemGray5.cgColor
            textView.textContainerInset = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 0)
        }
    }
    var imagePicker = UIImagePickerController()
    var isPhoto = false
    var isFile = false
    var isMicraphone = true
    
    var messages: [String] = []{
        didSet{
            self.tableView.reloadData()
            self.scrollToBottom()
        }
    }
    
    var photos : [UIImage] = []{
        didSet{
            self.tableView.reloadData()
            //self.scrollToBottom()
        }
    }
    var file : [String] = [] {
        didSet{
            self.tableView.reloadData()
            //self.scrollToBottom()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
        
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func leftBtnTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photo = UIAlertAction(title: "Photo", style: .default) { [self] _ in

            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.mediaTypes = [kUTTypeImage as String]
            vc.allowsEditing = true
            vc.delegate = self
            
            self.present(vc, animated: true, completion: nil)
            }
            
    
        
        let file = UIAlertAction(title: "File", style: .default) { _ in
            self.isFile = true
            self.isPhoto = false
            self.file.append("2")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(photo)
        alert.addAction(file)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        isFile = false
        isPhoto = false
        if !textView.text!.isEmpty && !isMicraphone{
            
            messages.append(textView.text!)
            textView.text.removeAll()
        }else{
            
        }
    }
    


}

//MARK:- TableView Delegate
extension MainVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPhoto{
            
            return photos.count
        }else if isFile{
            return file.count
        }else{
            return messages.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isPhoto{
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTVC.identifier, for: indexPath) as! PhotoTVC
            
            cell.updadeCell(with: photos[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }else if isFile{
            let cell = tableView.dequeueReusableCell(withIdentifier: FileTVC.identifier, for: indexPath) as! FileTVC
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageTVC.identifier, for: indexPath) as! MessageTVC
            
            if indexPath.row % 2 == 0{
                cell.rightLbl(with: messages[indexPath.row])
                cell.leftView.isHidden = true
                cell.rightView.isHidden = false
            }else{
                cell.leftLbl(with: messages[indexPath.row])
                cell.rightView.isHidden = true
                cell.leftView.isHidden = false
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
}


//MARK:- TextView Delegate

extension MainVC: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.contentSize.height >= 150 {
            textView.isScrollEnabled = true
        }else {
            
            textView.isScrollEnabled = false
        }
        return true
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if !textView.text.isEmpty{
            sendBtn.setBackgroundImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
            sendBtn.tintColor = .systemBlue
            isMicraphone = false
        }else{
            sendBtn.setBackgroundImage(UIImage(systemName: "mic"), for: .normal)
            sendBtn.tintColor = .systemGray2
            isMicraphone = true
            }
    }
    
}


//MARK: - Keyboard Handling

extension MainVC {
    
    func registerKeyboardNotifications() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
    }
    @objc func hideKeyboard() {
        self.view.endEditing(true)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let size = keyboardInfo.cgRectValue.size
        
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -size.height)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.view.transform = .identity
        }
    }

}

//MARK: - ImageView Delegate

extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        switch mediaType {
        case kUTTypeImage:
            self.isPhoto = true
            let editedImg = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            photos.append(editedImg)

        default:
            break
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}



    
