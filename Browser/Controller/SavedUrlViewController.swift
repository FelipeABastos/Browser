//
//  SavedUrlViewController.swift
//  Browser
//
//  Created by Felipe Amorim Bastos on 11/02/20.
//  Copyright © 2020 Felipe Amorim Bastos. All rights reserved.
//

import UIKit

class SavedUrlViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var urlSaved: Array<Url> = []
    
    @IBOutlet var tbUrl: UITableView?
    
    //-----------------------------------------------------------------------
    //    MARK: UIViewController
    //-----------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlSaved = get()
        tbUrl?.reloadData()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.post(name: NSNotification.Name("refreshState"), object: nil)
    }
    
    //-----------------------------------------------------------------------
    //    MARK: UITableView Delegate / Datasource
    //-----------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlSaved.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let urls: Url = urlSaved[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "urlCell") as! UrlCell
        cell.loadUI(item: urls)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            urlSaved.remove(at: indexPath.row)
            
            var urlDictionary = UserDefaults.standard.value(forKey: "urls") as? Array<Dictionary<String,String>>
            urlDictionary?.remove(at: indexPath.row)
            UserDefaults.standard.set(urlDictionary, forKey: "urls")
        }
        tbUrl?.reloadData()
    }
    
    //-----------------------------------------------------------------------
    //    MARK: Custom methods
    //-----------------------------------------------------------------------

    func get() -> Array<Url> {
        
        var list: Array<Url> = []
         
        if let urls = UserDefaults.standard.array(forKey: "urls") as? Array<Dictionary<String,String>> {
            
            for item in urls {
                
                let object = Url(url: item["url"] ?? "",
                                 date: item["date"] ?? "")
                list.append(object)
            }
        }
        return list
    }
    
    @IBAction func backButton() {
        
        self.dismiss(animated: true, completion: nil)
    }
}
