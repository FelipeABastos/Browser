//
//  ViewController.swift
//  Browser
//
//  Created by Felipe Amorim Bastos on 05/02/20.
//  Copyright © 2020 Felipe Amorim Bastos. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {
    
    @IBOutlet var btnBack: UIButton?
    @IBOutlet var btnFoward: UIButton?
    @IBOutlet var btnShare: UIButton?
    @IBOutlet var webView: WKWebView?
    @IBOutlet var txtUrl: UITextField?
    //-----------------------------------------------------------------------
    //    MARK: UIViewController
    //-----------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView?.navigationDelegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let urlString: String = "https://www.google.com"
        txtUrl?.text = urlString
        
        let url: URL = URL(string: urlString)!
        let urlRequest: URLRequest = URLRequest(url: url)
        webView?.load(urlRequest)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (txtUrl?.text?.contains("http://"))! || (txtUrl?.text?.contains("https://"))! {
            let urlString: String = txtUrl!.text!
            
            let url: URL = URL(string: urlString)!
            let urlRequest: URLRequest = URLRequest(url: url)
            webView?.load(urlRequest)
        }else{
            let urlString: String = "http://\(txtUrl?.text ?? "")"
            
            let url: URL = URL(string: urlString)!
            let urlRequest: URLRequest = URLRequest(url: url)
            webView?.load(urlRequest)
        }
        
        
        
        textField.resignFirstResponder()
        
        return true
    }
    
    //-----------------------------------------------------------------------
    //    MARK: Custom methods
    //-----------------------------------------------------------------------
    
    @IBAction func share() {
        let activityVC = UIActivityViewController(activityItems: [txtUrl!.text!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func backButton() {
            webView?.goBack()
    }
    
    @IBAction func fowardButton() {
            webView?.goForward()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {        
        txtUrl?.text = webView.url?.absoluteString
    }
}

