//
//  CardController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/12/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

class CardController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.backgroundColor = .black
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true

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
