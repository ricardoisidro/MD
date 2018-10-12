//
//  PartnersViewController.swift
//  Maguen
//
//  Created by Ricardo Isidro on 10/11/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import WebKit
import UIKit

class StoreController: UIViewController {

    @IBOutlet weak var webViewPartners: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://www.superemet.com/")
        let req = URLRequest(url: url!)
        webViewPartners.load(req)
        // Do any additional setup after loading the view, typically from a nib.
    }


}

