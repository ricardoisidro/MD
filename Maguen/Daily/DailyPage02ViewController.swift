//
//  DailyPage02ViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/19/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

class DailyPage02ViewController: UIViewController {

    @IBOutlet weak var img02: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        img02.isUserInteractionEnabled = true
        img02.addGestureRecognizer(pinchGesture)
    }
    
    @objc func pinchGesture(sender: UIPinchGestureRecognizer) {
        sender.view?.transform = ((sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!)
        sender.scale = 1.0
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
