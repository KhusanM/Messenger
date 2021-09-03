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
    var url: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: URL(string: url)!))
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
