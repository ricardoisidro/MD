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
    @IBOutlet weak var cardPhoto: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtSurname: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.backgroundColor = .black
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        
        self.view.backgroundColor = MaguenColors.black1

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let validString = UserDefaults.standard.string(forKey: "name") ?? ""
        let sessionisEmpty = (validString == "")
        if sessionisEmpty {
        }
        else {
            let imageDecoded: Data = Data(base64Encoded: UserDefaults.standard.string(forKey: "photo") ?? "")!
            let avatarImage: UIImage = UIImage(data: imageDecoded) ?? #imageLiteral(resourceName: "img_foto_default")
            cardPhoto.image = avatarImage
            
            txtName.text = UserDefaults.standard.string(forKey: "name")
            txtSurname.text = UserDefaults.standard.string(forKey: "surname1")
            //let date = UserDefaults.standard.string(forKey: "vigency")
            //date?.index(after: 10)
        }
        
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
