//
//  MainVC.swift
//  Messenger
//
//  Created by Kh's MacBook on 10.08.2021.
//

import UIKit
import MobileCoreServices
import AVFoundation
import CloudKit



protocol ChatDelegate {
    func didSelectImage(index: IndexPath)
    func didSelectDocument(index: IndexPath)
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
    
    var documentName: String?
    var documentURL: URL?
    var documentSize: String?
    var mediaType: MediaType?
    
    var audiFiles: String?
    
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
            tableView.register(AudioTVC.unib(), forCellReuseIdentifier: AudioTVC.identifair)
        }
    }
    
    @IBOutlet weak var sendBtn: RecordBtn!{
        didSet{
            sendBtn.delegate = self
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
    
    
    var isMicraphone = true
    var messages: [MessageData] = []
    
    var keyboardHeight: CGFloat!
    var isFirstUser = true
    
    var indexEditText : IndexPath!
    var isEditingText = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        keyboardHandling()
        navigationItem.title = "Chat"
        
        
    }
    
    private func tableViewReload(){
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath.init(row: messages.count - 1, section: 0)], with: .fade)
        tableView.endUpdates()
        tableView.scrollToRow(at: IndexPath(row: messages.count-1, section: 0), at: .top, animated: true)
    }
    
    private func keyboardHandling(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    
    func openFilePicker() {
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: UIDocumentPickerMode.open)
        documentPicker.delegate = self
        
        self.present(documentPicker,animated: true,completion: nil)
    }
    
    private func realTime() -> String{
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        let dateString = df.string(from: date)
        
        return dateString
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
        textView.isScrollEnabled = false
        
        if isEditingText{
            messages[indexEditText.row].text = textView.text
            tableView.reloadData()
            textView.text.removeAll()
            isEditingText = false
        }else{
            if !textView.text!.isEmpty && !isMicraphone {
                messages.append(MessageData(text: textView.text, isFistUser: isFirstUser))
                
                tableViewReload()
                isFirstUser = !isFirstUser
                textView.text.removeAll()
            }else{
                
            }
            
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
            cell.realTimeLbl.text = realTime()
            cell.updadeCell(with: messages[indexPath.row])
            cell.selectionStyle = .none
            return cell
            
        }else if messages[indexPath.row].text != nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageTVC.identifier, for: indexPath) as! MessageTVC
            cell.timeLbl.text = realTime()
            cell.updateCell(message: messages[indexPath.row])
            
            cell.selectionStyle = .none
            
            return cell
            
        }else if messages[indexPath.row].documentURL != nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: FileTVC.identifier, for: indexPath) as! FileTVC
            cell.index = indexPath
            cell.timeLbl.text = realTime()
            cell.delegate = self
            cell.updateCell(file: messages[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: AudioTVC.identifair, for: indexPath) as! AudioTVC
            cell.index = indexPath
            cell.realTimeLbl.text = realTime()
            cell.updateCell(ar: messages[indexPath.row])
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {[self] _  in
            if messages[indexPath.row].text != nil{
                if messages[indexPath.row].isFistUser{
                    let copy = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { _ in
                        UIPasteboard.general.string = messages[indexPath.row].text
                    }
                    
                    let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { _ in
                        self.isEditingText = true
                        self.indexEditText = indexPath
                        self.textView.text = messages[indexPath.row].text
                    }
                    let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                        self.messages.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    return UIMenu(title: "", children: [copy,edit, delete])
                    
                }else{
                    let copy = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { _ in
                        UIPasteboard.general.string = messages[indexPath.row].text
                    }
                    
                    let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                        self.messages.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    return UIMenu(title: "", children: [copy, delete])
                }
            
            }else if messages[indexPath.row].image != nil{
                let saveToCameraRoll = UIAction(title: "Save To Camera Roll", image: UIImage(systemName: "square.and.arrow.down")) { _ in
                    UIImageWriteToSavedPhotosAlbum(messages[indexPath.row].image!, nil, nil, nil)
                }
                
                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    self.messages.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
                return UIMenu(title: "", children: [saveToCameraRoll, delete])
                
            }else{
                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    self.messages.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
                return UIMenu(title: "", children: [delete])
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didselect")
    }
    
}


//MARK:- TextView Delegate

extension MainVC: UITextViewDelegate{
    
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
            isMicraphone = false
        }else{
            sendBtn.setBackgroundImage(UIImage(named: "mic"), for: .normal)
            if #available(iOS 13.0, *) {
                sendBtn.tintColor = .systemGray2
            } else {
                // Fallback on earlier versions
            }
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
            tableViewReload()
            isFirstUser = !isFirstUser
        default:
            break
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- Document

extension MainVC: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        
        guard let myURL = urls.first else {return}
        
        guard let filename = urls.first?.lastPathComponent else{ return}
        
        
        // Start accessing a security-scoped resource.
        guard myURL.startAccessingSecurityScopedResource() else {
            // Handle the failure here.
            return
        }
        
        // Make sure you release the security-scoped resource when you finish.
        defer { myURL.stopAccessingSecurityScopedResource() }

        // Use file coordination for reading and writing any of the URL’s content.
        var error: NSError? = nil
        NSFileCoordinator().coordinate(readingItemAt: myURL, error: &error) { (url) in

            let keys : [URLResourceKey] = [.nameKey, .isDirectoryKey]

            // Get an enumerator for the directory's content.
            guard let fileList =
                    FileManager.default.enumerator(at: url, includingPropertiesForKeys: keys) else {
                Swift.debugPrint("*** Unable to access the contents of \(url.path) ***\n")
                return
            }

            for case let file as URL in fileList {
                // Start accessing the content's security-scoped URL.
                guard url.startAccessingSecurityScopedResource() else {
                    // Handle the failure here.
                    continue
                }

                // Do something with the file here.
                Swift.debugPrint("chosen file: \(file.lastPathComponent)")

                // Make sure you release the security-scoped resource when you finish.
                url.stopAccessingSecurityScopedResource()


            }
            print(url)

        }
        
        
         self.messages.append(MessageData(isFistUser: isFirstUser, documentName: filename, documentURL: myURL, documentSize: "\(myURL.fileSizeString)"))
        
        
        tableViewReload()
        
    }
    
}


//MARK:- Keyboard Handling


extension MainVC{
    
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

extension MainVC: ChatDelegate{
    
    
    func didSelectDocument(index: IndexPath) {
        
        if #available(iOS 13.0, *) {
            let vc = DocumentVC(nibName: "DocumentVC", bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            vc.url = messages[index.row].documentURL
            navigationController?.pushViewController(vc, animated: true)
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    func didSelectImage(index: IndexPath) {
        if messages[index.row].image != nil{
            
            if #available(iOS 13.0, *) {
                let vc = ImagePresentVC(nibName: "ImagePresentVC", bundle: nil)
                vc.modalPresentationStyle = .fullScreen
                vc.img = messages[index.row].image!
                navigationController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
            }
            
        }
    }
    
    
}


extension MainVC: RecordBtnDelegate{
    func getUrl(url: String) {
        
        messages.append(MessageData(isFistUser: isFirstUser, audiFiles: url))
        
        tableViewReload()
    }
    
    
}
