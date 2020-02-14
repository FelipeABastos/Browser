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
    
    var urlSaved: Array<Url> = []
    
    @IBOutlet var btnStar: UIButton?
    
    @IBOutlet var btnBack: UIButton?
    @IBOutlet var btnFoward: UIButton?
    @IBOutlet var btnShare: UIButton?
    @IBOutlet var webView: WKWebView?
    @IBOutlet var txtUrl: UITextField?
    //-----------------------------------------------------------------------
    //    MARK: UIViewController
    //-----------------------------------------------------------------------
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshFavorite),
                                               name: NSNotification.Name("refreshState"),
                                               object: nil)
        
        txtUrl?.keyboardAppearance = .dark
        webView?.navigationDelegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let urlString: String = "https://github.com/FelipeABastos"
        txtUrl?.text = urlString
        
        let url: URL = URL(string: urlString)!
        let urlRequest: URLRequest = URLRequest(url: url)
        webView?.load(urlRequest)
        
        refreshFavorite()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        self.btnStar?.setImage(#imageLiteral(resourceName: "BookMark"), for: .normal)
        self.btnStar?.isEnabled = false
        
        return true
    }
    
    //-----------------------------------------------------------------------
    //    MARK: Custom methods
    //-----------------------------------------------------------------------
    
    @objc func refreshFavorite() {
        
        if exists(url: txtUrl?.text ?? "") {
            self.btnStar?.setImage(#imageLiteral(resourceName: "BookMarkFilled"), for: .normal)
        }else{
            self.btnStar?.setImage(#imageLiteral(resourceName: "BookMark"), for: .normal)
        }
    }
    
    @IBAction func goToFavorites() {
        
        let favoriteVC = storyboard?.instantiateViewController(identifier: "SavedUrlView") as! SavedUrlViewController
        
        self.present(favoriteVC, animated: true, completion: nil)
    }
    
    @IBAction func favorite() {
        
        let dateFormatter : DateFormatter = DateFormatter()
        //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        let dic = ["date": dateString,
                   "url": txtUrl?.text ?? ""]
        
        if var urlDictionary = UserDefaults.standard.value(forKey: "urls") as? Array<Dictionary<String,String>> {
            
            if exists(url: txtUrl?.text ?? "") {
                
                print("removed from favorites")
                urlDictionary.remove(at: indexUrl(url: txtUrl?.text ?? ""))
                UserDefaults.standard.set(urlDictionary, forKey: "urls")
                UserDefaults.standard.synchronize()
                
                btnStar?.setImage(#imageLiteral(resourceName: "BookMark"), for: .normal)
                
            }else{
                
                print("added to favorites")
                
                urlDictionary.append(dic)
                UserDefaults.standard.set(urlDictionary, forKey: "urls")
                UserDefaults.standard.synchronize()
                
                btnStar?.setImage(#imageLiteral(resourceName: "BookMarkFilled"), for: .normal)
            }
        }else{
            UserDefaults.standard.set([dic], forKey: "urls")
            btnStar?.setImage(#imageLiteral(resourceName: "BookMarkFilled"), for: .normal)
        }
    }
    
    func exists(url: String) -> Bool {
        
        if let urlDictionary = UserDefaults.standard.value(forKey: "urls") as? Array<Dictionary<String,String>> {
            
            var counter = 0
            
            for item in urlDictionary {
                
                if item["url"] == url {
                    print("Found \(url) for index \(counter)")
                    return true
                }
                counter += 1
            }
        }
        return false
    }
    
    func indexUrl(url: String) -> Int {
        
            var counter = 0
        
        if let urlDictionary = UserDefaults.standard.value(forKey: "urls") as? Array<Dictionary<String,String>> {
            
            for item in urlDictionary {
                if item["url"] == url {
                    print("Found \(url) for index \(counter)")
                    return counter
                }
                counter += 1
            }
        }
        return counter
    }
    
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
        
        self.btnStar?.isEnabled = true
        
        refreshFavorite()
    }
}

