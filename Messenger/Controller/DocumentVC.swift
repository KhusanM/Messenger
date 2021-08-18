//
//  DocumentVC.swift
//  Messenger
//
//  Created by Kh's MacBook on 17.08.2021.
//


import UIKit
import WebKit


class DocumentVC: UIViewController ,WKNavigationDelegate{


    var webView: WKWebView!
    var url: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(url)
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        let shareBtn = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareBtnTapped))
        
        navigationItem.rightBarButtonItem = shareBtn
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
