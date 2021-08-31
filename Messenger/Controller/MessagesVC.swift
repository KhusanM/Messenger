//
//  MessagesVC.swift
//  Messenger
//
//  Created by Kh's MacBook on 10.08.2021.
//

import UIKit
import MobileCoreServices
import AVFoundation
import CloudKit






class MessagesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
            tableView.register(MessageTVC.unib(), forCellReuseIdentifier: MessageTVC.identifier)
            tableView.register(PhotoTVC.unib(), forCellReuseIdentifier: PhotoTVC.identifier)
            tableView.register(FileTVC.unib(), forCellReuseIdentifier: FileTVC.identifier)
            tableView.register(AudioTVC.unib(), forCellReuseIdentifier: AudioTVC.identifair)
        }
    }
    
    @IBOutlet weak var sendBtn: RecordBtn!{
        didSet{
            //sendBtn.delegate = self
            sendBtn.layer.cornerRadius = 15
        }
    }
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.delegate = self
            textView.layer.cornerRadius = textView.bounds.height * 0.47
            textView.layer.borderWidth = 0.5
            textView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            textView.textContainerInset = UIEdgeInsets(top: 7, left: 7, bottom: 5, right: 0)
        }
    }
    
    @IBOutlet weak var bottomConteinerView: UIView!{
        didSet{
            bottomConteinerView.layer.borderWidth = 0.5
            bottomConteinerView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
    
    //var messages: [[MessageData]] = [[],[]]
    
    var keyboardHeight: CGFloat!
    
    //Text editing
    var indexEditText : IndexPath!
    var isEditingText = false
    var chatID: Int = 0
    var userID: Int = 0
    
    var messageDM : [[MessagePageDM]] = [[],[]]
    let totalItems = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHandling()
        getMessageDM()
        
        
        if #available(iOS 13.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "circle"), style: .done, target: self, action: #selector(reload))
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func reload(){
        messageDM = [[],[]]
        getMessageDM()
    }
    
    private func getMessageDM(){
        Network.requestWithToken(url: "/message/get-paging", method: .post, param: ["chat_id" : self.chatID, "page" : 1, "limit": totalItems]) { data in
            if let data = data{
                for i in data["data"].arrayValue {
                                    
                    let dm = MessagePageDM(type: i["type"].stringValue, text: i["text"].stringValue, from_ID: i["from_id"].intValue, time: i["created_at"].stringValue)
                    self.messageDM[0].insert(dm, at: 0)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    private func sendMessage(){
        Network.requestWithToken(url: "/message/send", method: .post, param: ["type" : "text", "text" : textView.text!, "user_id": userID]) { data in
            if let data = data{
                
                
                let dm = MessagePageDM(type: data["data"]["type"].stringValue, text: data["data"]["text"].stringValue, from_ID: data["data"]["from_id"].intValue, time: data["data"]["created_at"].stringValue)
                
                self.messageDM[0].append(dm)
                
                
            }
            
            self.tableViewReload(section: 0)
            
        }
    }
    
    private func tableViewReload(section: Int){
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath.init(row: messageDM[section].count - 1, section: section)], with: .fade)
        tableView.endUpdates()
        tableView.scrollToRow(at: IndexPath(row: messageDM[section].count-1, section: section), at: .top, animated: true)
    }
    
    private func keyboardHandling(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func openFilePicker() {
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: UIDocumentPickerMode.open)
        //documentPicker.delegate = self
        
        self.present(documentPicker,animated: true,completion: nil)
    }
    
    private func showMediaAlert(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photo = UIAlertAction(title: "Photo", style: .default) { [self] _ in
            
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.mediaTypes = [kUTTypeImage as String]
            
            //vc.delegate = self
            
            self.present(vc, animated: true, completion: nil)
        }
        
        let file = UIAlertAction(title: "File", style: .default) { [self] _ in
            openFilePicker()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(photo)
        alert.addAction(file)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func mediaBtnTapped(_ sender: Any) {
        showMediaAlert()
    }
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        textView.isScrollEnabled = false
        
        if isEditingText{
            //messages[indexEditText.section][indexEditText.row].text = textView.text
            tableView.reloadRows(at: [indexEditText], with: .fade)
            textView.text.removeAll()
            isEditingText = false
        }else{
            if !textView.text!.isEmpty {
                sendMessage()
                textView.text.removeAll()
            }else{
                
            }
            
        }
    }
    
}

//MARK:- TableView Delegate
extension MessagesVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageDM[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messageDM.count
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.text = "August 31"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let originalContentSize = label.intrinsicContentSize
        
        
        let containerView = UIView()
        containerView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: originalContentSize.height + 12).isActive = true
        label.widthAnchor.constraint(equalToConstant: originalContentSize.width + 16).isActive = true
        
        
        label.layer.masksToBounds = true
        label.layer.cornerRadius = (originalContentSize.height + 12) / 2
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if messageDM[section].count == 0{
            return 0
        }else{
            return 29
        }
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.row == messageDM[indexPath.section].count - 1 { // last cell
//            if totalItems > messageDM[indexPath.section].count { // more items to fetch
//                getMessageDM() // increment `fromIndex` by 15 before server call
//                print("++++")
//            }
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTVC.identifier, for: indexPath) as! MessageTVC
        cell.updateCell(message: messageDM[indexPath.section][indexPath.row])
        cell.selectionStyle = .none
        
        return cell
        
//        if messages[indexPath.section][indexPath.row].image != nil{
//            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTVC.identifier, for: indexPath) as! PhotoTVC
//            cell.index = indexPath
//            cell.delegate = self
//            cell.realTimeLbl.text = realTime()
//            cell.updadeCell(with: messages[indexPath.section][indexPath.row])
//            cell.selectionStyle = .none
//            return cell
//
//        }else if messages[indexPath.section][indexPath.row].text != nil{
//            let cell = tableView.dequeueReusableCell(withIdentifier: MessageTVC.identifier, for: indexPath) as! MessageTVC
//            cell.timeLbl.text = realTime()
//            cell.updateCell(message: messages[indexPath.section][indexPath.row])
//
//            cell.selectionStyle = .none
//
//            return cell
//
//        }else if messages[indexPath.section][indexPath.row].documentURL != nil{
//            let cell = tableView.dequeueReusableCell(withIdentifier: FileTVC.identifier, for: indexPath) as! FileTVC
//            cell.index = indexPath
//            cell.timeLbl.text = realTime()
//            cell.delegate = self
//            cell.updateCell(file: messages[indexPath.section][indexPath.row])
//            cell.selectionStyle = .none
//            return cell
//        }else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: AudioTVC.identifair, for: indexPath) as! AudioTVC
//            cell.index = indexPath
//            cell.realTimeLbl.text = realTime()
//            cell.updateCell(ar: messages[indexPath.section][indexPath.row])
//
//            cell.selectionStyle = .none
//            return cell
//        }
    }
    
    @available(iOS 13.0, *)
//    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//
//        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) {[self] _  in
//
//            if let _ = tableView.cellForRow(at: indexPath) as? MessageTVC {
//
//                if messages[indexPath.section][indexPath.row].isFistUser{
//                    let copy = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { _ in
//                        UIPasteboard.general.string = messages[indexPath.section][indexPath.row].text
//                    }
//
//                    let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { _ in
//                        self.isEditingText = true
//                        self.indexEditText = indexPath
//                        self.textView.text = messages[indexPath.section][indexPath.row].text
//                    }
//                    let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            self.messages[indexPath.section].remove(at: indexPath.row)
//                            self.tableView.deleteRows(at: [indexPath], with: .fade)
//                        }
//                    }
//                    return UIMenu(title: "", children: [copy,edit, delete])
//
//                }else{
//                    let copy = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { _ in
//                        UIPasteboard.general.string = messages[indexPath.section][indexPath.row].text
//                    }
//
//                    let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            self.messages[indexPath.section].remove(at: indexPath.row)
//                            self.tableView.deleteRows(at: [indexPath], with: .fade)
//                        }
//                    }
//                    return UIMenu(title: "", children: [copy, delete])
//                }
//
//            }else if let _ = tableView.cellForRow(at: indexPath) as? PhotoTVC{
//                let saveToCameraRoll = UIAction(title: "Save To Camera Roll", image: UIImage(systemName: "square.and.arrow.down")) { _ in
//                    UIImageWriteToSavedPhotosAlbum(messages[indexPath.section][indexPath.row].image!, nil, nil, nil)
//                }
//
//                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        self.messages[indexPath.section].remove(at: indexPath.row)
//                        self.tableView.deleteRows(at: [indexPath], with: .fade)
//                    }
//                }
//                return UIMenu(title: "", children: [saveToCameraRoll, delete])
//
//            }else{
//                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        self.messages[indexPath.section].remove(at: indexPath.row)
//                        self.tableView.deleteRows(at: [indexPath], with: .fade)
//                    }
//                }
//                return UIMenu(title: "", children: [delete])
//            }
//        }
//    }
//
    
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        return makeTargetedPreview(for: configuration)
        
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    
    @available(iOS 13.0, *)
    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        
        if let cell = tableView.cellForRow(at: indexPath) as? MessageTVC {
            return UITargetedPreview(view: cell.containerView, parameters: parameters)
        }else if let cell = tableView.cellForRow(at: indexPath) as? FileTVC{
            return UITargetedPreview(view: cell.containerView, parameters: parameters)
        }else if let cell = tableView.cellForRow(at: indexPath) as? PhotoTVC{
            return UITargetedPreview(view: cell.containerView, parameters: parameters)
        }else if let cell = tableView.cellForRow(at: indexPath) as? AudioTVC{
            return UITargetedPreview(view: cell.containerView, parameters: parameters)
        }
        return UITargetedPreview(view: UIView())

    }
    
}


//MARK:- TextView Delegate

extension MessagesVC: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.contentSize.height >= 150 {
            textView.isScrollEnabled = true
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if !textView.text.isEmpty{
            textView.becomeFirstResponder()
            if #available(iOS 13.0, *) {
                sendBtn.setBackgroundImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
            sendBtn.tintColor = .systemBlue
        }else{
            sendBtn.setBackgroundImage(UIImage(named: "mic"), for: .normal)
            if #available(iOS 13.0, *) {
                sendBtn.tintColor = .systemGray2
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    
}


//MARK: - ImageView Delegate

//extension MessagesVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
//        switch mediaType {
//        case kUTTypeImage:
//
//            let originalImg = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//            let width = Int(originalImg.size.width / 10)
//            let height = Int(originalImg.size.height / 10)
//
//            messages[0].append(MessageData(text: nil, isFistUser: isFirstUser, image: originalImg, imageHeight: height, imageWidth: width))
//            tableViewReload(section: 0)
//            isFirstUser = !isFirstUser
//        default:
//            break
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//}

//MARK:- Document
//
//extension MessagesVC: UIDocumentPickerDelegate{
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//
//        guard let myURL = urls.first else {return}
//        guard let filename = urls.first?.lastPathComponent else{ return}
//        // Start accessing a security-scoped resource.
//        guard myURL.startAccessingSecurityScopedResource() else {
//            // Handle the failure here.
//            return
//        }
//        // Make sure you release the security-scoped resource when you finish.
//        defer { myURL.stopAccessingSecurityScopedResource() }
//        // Create data to be saved
//        let data = try! Data.init(contentsOf: myURL)
//
//        let surl = self.getDocumentsDirectory().appendingPathComponent(filename)
//        do {
//            try data.write(to: surl)
//        } catch {
//            print(error.localizedDescription)
//        }
//
//        self.messages[0].append(MessageData(isFistUser: isFirstUser, documentName: filename, documentURL: surl, documentSize: "\(myURL.fileSizeString)"))
//
//        tableViewReload(section: 0)
//    }
//
//    func getDocumentsDirectory() -> URL {
//        // find all possible documents directories for this user
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        // just send back the first one, which ought to be the only one
//        return paths[0]
//    }
//
//}


//MARK:- Keyboard Handling


extension MessagesVC{
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        
        if let keyFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyFrame.cgRectValue
            keyboardHeight = keyboardRect.height
            
            if UIScreen.main.bounds.height < 670{
                
                UIView.animate(withDuration: 0.1) {
                    self.bottomConteinerView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight)
                } completion: { (_) in }
                tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50+self.keyboardHeight, right: 0)
                //tableView.scrollToBottom(with: true)
                
            }else{
                
                UIView.animate(withDuration: 0.1) {
                    self.bottomConteinerView.transform = CGAffineTransform(translationX: 0, y: -(self.keyboardHeight-20))
                } completion: { (_) in }
                tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50+self.keyboardHeight, right: 0)
                //tableView.scrollToBottom(with: true)
                
            }
            
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: Notification) {
        
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.init(rawValue: UInt(curveValue))) {
            self.bottomConteinerView.transform = .identity
        } completion: { (_) in }
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
        
    }
}


// MARK:- Push To ImagePresentVC And File and Voice

//extension MessagesVC: ChatDelegate{
//
//    //FileVC
//    func didSelectDocument(index: IndexPath) {
//
//        if #available(iOS 13.0, *) {
//            let vc = DocumentVC(nibName: "DocumentVC", bundle: nil)
//            vc.modalPresentationStyle = .fullScreen
//            vc.url = messages[index.section][index.row].documentURL
//            navigationController?.pushViewController(vc, animated: true)
//        } else {
//            // Fallback on earlier versions
//        }
//
//
//    }
//
//    //ImageVC
//    func didSelectImage(index: IndexPath) {
//        if messages[index.section][index.row].image != nil{
//
//            if #available(iOS 13.0, *) {
//                let vc = ImagePresentVC(nibName: "ImagePresentVC", bundle: nil)
//                vc.modalPresentationStyle = .fullScreen
//                vc.img = messages[index.section][index.row].image!
//                navigationController?.pushViewController(vc, animated: true)
//            } else {
//                // Fallback on earlier versions
//            }
//
//        }
//    }
//
//
//}


//MARK:- Record Button Delegate
//extension MessagesVC: RecordBtnDelegate{
//    func getUrl(url: String) {
//
//        messages[0].append(MessageData(isFistUser: isFirstUser, audiFiles: url))
//
//        tableViewReload(section: 0)
//    }
//
//
//}
