//
//  MagazinePage01ViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/19/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

class MagazinePage01ViewController: UIViewController {

    @IBOutlet weak var img01: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        img01.isUserInteractionEnabled = true
        img01.addGestureRecognizer(pinchGesture)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func pinchGesture(sender: UIPinchGestureRecognizer) {
        self.view.bringSubviewToFront(img01)
        sender.view?.transform = ((sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!)
        sender.scale = 1.0
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.img01)
        if let view = recognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            
        }
        recognizer.setTranslation(CGPoint.zero, in: self.img01)
    }

}
