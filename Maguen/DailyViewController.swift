//
//  DailyViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/17/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

class DailyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor

        // Do any additional setup after loading the view.
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
