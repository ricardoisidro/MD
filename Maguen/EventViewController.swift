//
//  EventViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/17/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let lineWidth: CGFloat = 1.0
        context.setLineWidth(lineWidth)
        context.setStrokeColor(UIColor.lightGray.cgColor)
        let startingPoint = CGPoint(x: 0, y: rect.size.height - lineWidth)
        let endingPoint = CGPoint(x: rect.size.width, y: rect.size.height - lineWidth)
        context.move(to: startingPoint )
        context.addLine(to: endingPoint )
        context.strokePath()
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
