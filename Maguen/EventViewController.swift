//
//  EventViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/17/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var imgEvent: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popView.layer.cornerRadius = 10
        popView.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        imgEvent.isUserInteractionEnabled = true
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        imgEvent.addGestureRecognizer(pinchGesture)
        
    }
    
    @objc func pinchGesture(sender: UIPinchGestureRecognizer) {
        sender.view?.transform = ((sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!)
        sender.scale = 1.0
    }

    @IBAction func closePopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
