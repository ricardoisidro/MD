//
//  KashrutController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/12/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import WebKit

class KashrutController: UIViewController {

    @IBOutlet weak var webViewKashrut: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "http://www.kosher.com.mx/consumidor/index.php?ver=productos_certificados")
        let req = URLRequest(url: url!)
        webViewKashrut.load(req)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
