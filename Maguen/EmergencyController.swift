//
//  EmergencyController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/15/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

class EmergencyController: UIViewController {

    @IBOutlet weak var imgHatzala: UIImageView!
    @IBOutlet weak var imgCas: UIImageView!
    @IBOutlet weak var img1118: UIImageView!
    @IBOutlet weak var imgJebra: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgHatzala.layer.cornerRadius = self.imgHatzala.frame.size.width / 2
        imgHatzala.clipsToBounds = true
        
        imgCas.layer.cornerRadius = imgCas.frame.size.width / 2;
        imgCas.clipsToBounds = true
        
        img1118.layer.cornerRadius = img1118.frame.size.width / 2;
        img1118.clipsToBounds = true
        
        imgJebra.layer.cornerRadius = imgJebra.frame.size.width / 2;
        imgJebra.clipsToBounds = true
        
        self.view.backgroundColor = MaguenColors.black1
        
        //img1118.layer.cornerRadius = img

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnHatzala(_ sender: Any) {
        print("Calling hatzala")
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

