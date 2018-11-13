//
//  ChurchPrayDetailViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/13/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

class ChurchPrayDetailViewController: UIViewController {

    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var txtDay: UILabel!
    @IBOutlet weak var tableViewShajarit: UITableView!
    @IBOutlet weak var tableViewMinja: UITableView!
    @IBOutlet weak var tableViewArjit: UITableView!
    @IBOutlet weak var btnClose: UIButton!
    
    var txtTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modalView.layer.cornerRadius = 10
        modalView.layer.masksToBounds = true
        modalView.backgroundColor = MaguenColors.black2
        
        btnClose.layer.cornerRadius = 10
        btnClose.layer.masksToBounds = true
        
        if let textTitle = txtTitle {
            self.txtDay.text = textTitle
        }
        
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
