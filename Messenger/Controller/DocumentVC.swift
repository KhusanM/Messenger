//
//  DocumentVC.swift
//  Messenger
//
//  Created by Kh's MacBook on 17.08.2021.
//


import UIKit
import WebKit
import CloudKit

class DocumentVC: UIViewController, WKNavigationDelegate, UIDocumentInteractionControllerDelegate{


    var webView: WKWebView!
    var url: URL!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        let documentDirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//        let fileNameWithExtension = url.absoluteString
//        let indexFileUrl = documentDirUrl.appendingPathComponent(fileNameWithExtension)
//        if FileManager.default.fileExists(atPath: indexFileUrl.path) {
//            webView.loadFileURL(indexFileUrl, allowingReadAccessTo: documentDirUrl)
//        }
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        if #available(iOS 13.0, *) {
            let shareBtn = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareBtnTapped))
            navigationItem.rightBarButtonItem = shareBtn
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    
    
    @objc func shareBtnTapped() {
        
        let data = [url!] as [Any]
        let vc = UIActivityViewController(activityItems: data, applicationActivities: nil)
        
        present(vc, animated: true, completion: nil)
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }


}
