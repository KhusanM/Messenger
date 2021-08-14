//
//  MainVC.swift
//  Messenger
//
//  Created by Kh's MacBook on 10.08.2021.
//

import UIKit
import MobileCoreServices


protocol ChatDelegate {
    func didSelectImage(index: IndexPath)
}

struct MessageData {
    
    enum MediaType : String {
        case photo = "Photo"
        case audio = "Audio"
        case file = "File"
    }
    
    var text: String?
    var isFistUser: Bool
    var image: UIImage?
    var file: String?
    var mediaType: MediaType?
}


class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
            tableView.register(MessageTVC.unib(), forCellReuseIdentifier: MessageTVC.identifier)
            tableView.register(PhotoTVC.unib(), forCellReuseIdentifier: PhotoTVC.identifier)
            tableView.register(FileTVC.unib(), forCellReuseIdentifier: FileTVC.identifier)
        }
    }
    
    @IBOutlet weak var sendBtn: UIButton!
    
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
    
   // var imagePicker = UIImagePickerController()
    var isMicraphone = true
    var messages: [MessageData] = []
    
    var keyboardHeight: CGFloat!
    var isFirstUser = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture()
        navigationItem.title = "Chat"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    private func tapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
//    func scrollToBottom(){
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
//            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        }
//    }
    
    func openFilePicker() {
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: UIDocumentPickerMode.open)
        documentPicker.delegate = self
        
        self.present(documentPicker,animated: true,completion: nil)
    }
    
    
    @IBAction func leftBtnTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photo = UIAlertAction(title: "Photo", style: .default) { [self] _ in
            
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.mediaTypes = [kUTTypeImage as String]
            
            vc.delegate = self
            
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
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        
        if !textView.text!.isEmpty && !isMicraphone{
            messages.append(MessageData(text: textView.text, isFistUser: isFirstUser))
            
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath.init(row: messages.count - 1, section: 0)], with: .fade)
            tableView.endUpdates()
            tableView.scrollToRow(at: IndexPath(row: messages.count-1, section: 0), at: .top, animated: true)
            isFirstUser = !isFirstUser
            textView.text.removeAll()
        }else{
            
        }
    }
    
}

//MARK:- TableView Delegate
extension MainVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messages[indexPath.row].image != nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTVC.identifier, for: indexPath) as! PhotoTVC
            cell.index = indexPath
            cell.delegate = self
            cell.updadeCell(with: messages[indexPath.row])
            cell.selectionStyle = .none
            return cell
            
        }else if messages[indexPath.row].text != nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageTVC.identifier, for: indexPath) as! MessageTVC
            
            cell.updateCell(message: messages[indexPath.row])
            
            cell.selectionStyle = .none
            
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FileTVC.identifier, for: indexPath) as! FileTVC
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
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
            sendBtn.setBackgroundImage(UIImage(named: "mic"), for: .normal)
            sendBtn.tintColor = .systemGray2
            isMicraphone = true
        }
    }
    
}


//MARK: - ImageView Delegate

extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        switch mediaType {
        case kUTTypeImage:
            
            let originalImg = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            messages.append(MessageData(text: nil, isFistUser: isFirstUser, image: originalImg))
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: messages.count-1, section: 0), at: .top, animated: true)
            isFirstUser = !isFirstUser
        default:
            break
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}


extension MainVC: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        self.messages.append(MessageData(text: nil, isFistUser: isFirstUser, image: nil, file: "file", mediaType: nil))
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: messages.count-1, section: 0), at: .top, animated: true)
        print(urls)
    }
    
    
    //    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    //            let newUrls = urls.compactMap { (url: URL) -> URL? in
    //                // Create file URL to temporary folder
    //                var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
    //                // Apend filename (name+extension) to URL
    //                tempURL.appendPathComponent(url.lastPathComponent)
    //                do {
    //                    // If file with same name exists remove it (replace file with new one)
    //                    if FileManager.default.fileExists(atPath: tempURL.path) {
    //                        try FileManager.default.removeItem(atPath: tempURL.path)
    //                    }
    //                    // Move file from app_id-Inbox to tmp/filename
    //                    try FileManager.default.moveItem(atPath: url.path, toPath: tempURL.path)
    //                    return tempURL
    //                } catch {
    //                    print(error.localizedDescription)
    //                    return nil
    //                }
    //            }
    //            // ... do something with URLs
    //        }
}


//MARK:- Keyboard Handling


extension MainVC{
    
    
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        if let keyFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyFrame.cgRectValue
            keyboardHeight = keyboardRect.height-20
            
            
            UIView.animate(withDuration: 0.1) {
                self.bottomConteinerView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight)
            } completion: { (_) in }
            tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50+self.keyboardHeight, right: 0)
            //tableView.scrollToBottom(with: true)
        
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



extension MainVC: ChatDelegate{
    func didSelectImage(index: IndexPath) {
        if messages[index.row].image != nil{
            
            let vc = ImagePresentVC(nibName: "ImagePresentVC", bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            vc.img = messages[index.row].image!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
