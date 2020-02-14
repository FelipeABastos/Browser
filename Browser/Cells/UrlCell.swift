//
//  UrlCell.swift
//  Browser
//
//  Created by Felipe Amorim Bastos on 11/02/20.
//  Copyright © 2020 Felipe Amorim Bastos. All rights reserved.
//

import Foundation
import UIKit

class UrlCell: UITableViewCell {
    
    @IBOutlet var lblUrl: UILabel?
    @IBOutlet var lblDate: UILabel?
    
    func loadUI(item: Url) {
        
        lblUrl?.text = item.url
        lblDate?.text = item.date
    }
    
    
}
