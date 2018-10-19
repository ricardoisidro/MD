//
//  MagazinePage02ViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/19/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

class MagazinePage02ViewController: UIViewController {

    @IBOutlet weak var img02: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        img02.isUserInteractionEnabled = true
        img02.addGestureRecognizer(pinchGesture)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func pinchGesture(sender: UIPinchGestureRecognizer) {
        sender.view?.transform = ((sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!)
        sender.scale = 1.0
    }

}
