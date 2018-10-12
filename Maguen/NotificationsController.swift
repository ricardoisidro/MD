//
//  FirstViewController.swift
//  Maguen
//
//  Created by Ricardo Isidro on 10/11/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

class NotificationsController: UIViewController {

    @IBOutlet var myView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layerGrad = CAGradientLayer()
        layerGrad.frame = myView.bounds
        layerGrad.colors = [MaguenColors.blue2, MaguenColors.blue8]
        layerGrad.startPoint = CGPoint(x: 0.0, y: 0.0)
        layerGrad.endPoint = CGPoint(x: 1.0, y: 1.0)
        myView.layer.insertSublayer(layerGrad, at: 0)
    }


}

