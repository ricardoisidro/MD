//
//  TabBarController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/31/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    var maguenAnimatedIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self

        let firstItem = self.tabBar.subviews[0]
        
        
        
        self.maguenAnimatedIcon = (firstItem.subviews.first as! UIImageView)
        //self.maguenA
        self.maguenAnimatedIcon.contentMode = .scaleToFill
        //self.maguenAnimatedIcon.contentMode = .scaleAspectFit
        setupImageViewAnimation()
        maguenAnimatedIcon.startAnimating()
        
    }
    
    func setupImageViewAnimation() {
        
        maguenAnimatedIcon.animationImages = [#imageLiteral(resourceName: "logo200600"),#imageLiteral(resourceName: "logo200601"), #imageLiteral(resourceName: "logo200602"),#imageLiteral(resourceName: "logo200603"),#imageLiteral(resourceName: "logo200604"),#imageLiteral(resourceName: "logo200605"),#imageLiteral(resourceName: "logo200606"),#imageLiteral(resourceName: "logo200607"),#imageLiteral(resourceName: "logo200608"),#imageLiteral(resourceName: "logo200609"),#imageLiteral(resourceName: "logo200610"),#imageLiteral(resourceName: "logo200611"),#imageLiteral(resourceName: "logo200612"),#imageLiteral(resourceName: "logo200613"),#imageLiteral(resourceName: "logo200614"),#imageLiteral(resourceName: "logo200615"),#imageLiteral(resourceName: "logo200616"),#imageLiteral(resourceName: "logo200617"),#imageLiteral(resourceName: "logo200618"),#imageLiteral(resourceName: "logo200619"),#imageLiteral(resourceName: "logo200620"),#imageLiteral(resourceName: "logo200621"),#imageLiteral(resourceName: "logo200622"),#imageLiteral(resourceName: "logo200623"),#imageLiteral(resourceName: "logo200624"),#imageLiteral(resourceName: "logo200625"),#imageLiteral(resourceName: "logo200626"),#imageLiteral(resourceName: "logo200627"),#imageLiteral(resourceName: "logo200628"),#imageLiteral(resourceName: "logo200629"),#imageLiteral(resourceName: "logo200630"),#imageLiteral(resourceName: "logo200631"),#imageLiteral(resourceName: "logo200632"),#imageLiteral(resourceName: "logo200633"),#imageLiteral(resourceName: "logo200634"),#imageLiteral(resourceName: "logo200635"),#imageLiteral(resourceName: "logo200636"),#imageLiteral(resourceName: "logo200637"),#imageLiteral(resourceName: "logo200638"),#imageLiteral(resourceName: "logo200639"),#imageLiteral(resourceName: "logo200640"),#imageLiteral(resourceName: "logo200641"),#imageLiteral(resourceName: "logo200642"),#imageLiteral(resourceName: "logo200643"),#imageLiteral(resourceName: "logo200644"),#imageLiteral(resourceName: "logo200645"),#imageLiteral(resourceName: "logo200646"), #imageLiteral(resourceName: "logo200647"),#imageLiteral(resourceName: "logo200648"),#imageLiteral(resourceName: "logo200649"),#imageLiteral(resourceName: "logo200650"),#imageLiteral(resourceName: "logo200651"),#imageLiteral(resourceName: "logo200652"),#imageLiteral(resourceName: "logo200653"),#imageLiteral(resourceName: "logo200654"),#imageLiteral(resourceName: "logo200655"),#imageLiteral(resourceName: "logo200656"),#imageLiteral(resourceName: "logo200657"),#imageLiteral(resourceName: "logo200658"),#imageLiteral(resourceName: "logo200659"),#imageLiteral(resourceName: "logo200660"),#imageLiteral(resourceName: "logo200661"),#imageLiteral(resourceName: "logo200662"),#imageLiteral(resourceName: "logo200663"),#imageLiteral(resourceName: "logo200664"),#imageLiteral(resourceName: "logo200665"),#imageLiteral(resourceName: "logo200666"),#imageLiteral(resourceName: "logo200667"),#imageLiteral(resourceName: "logo200668"),#imageLiteral(resourceName: "logo200669"),#imageLiteral(resourceName: "logo200670"),#imageLiteral(resourceName: "logo200671"),#imageLiteral(resourceName: "logo200672"),#imageLiteral(resourceName: "logo200673"),#imageLiteral(resourceName: "logo200674"),#imageLiteral(resourceName: "logo200675"),#imageLiteral(resourceName: "logo200676"),#imageLiteral(resourceName: "logo200677"),#imageLiteral(resourceName: "logo200678"),#imageLiteral(resourceName: "logo200679"),#imageLiteral(resourceName: "logo200680"),#imageLiteral(resourceName: "logo200681"),#imageLiteral(resourceName: "logo200682"),#imageLiteral(resourceName: "logo200683"),#imageLiteral(resourceName: "logo200684"),#imageLiteral(resourceName: "logo200685"),#imageLiteral(resourceName: "logo200686"),#imageLiteral(resourceName: "logo200687"),#imageLiteral(resourceName: "logo200688"),#imageLiteral(resourceName: "logo200689"),#imageLiteral(resourceName: "logo200690"),#imageLiteral(resourceName: "logo200691"),#imageLiteral(resourceName: "logo200692"),#imageLiteral(resourceName: "logo200693"),#imageLiteral(resourceName: "logo200694"),#imageLiteral(resourceName: "logo200695"),#imageLiteral(resourceName: "logo200696"),#imageLiteral(resourceName: "logo200697"),#imageLiteral(resourceName: "logo200698"),#imageLiteral(resourceName: "logo200699"),#imageLiteral(resourceName: "logo200700"),#imageLiteral(resourceName: "logo200701"),#imageLiteral(resourceName: "logo200702"),#imageLiteral(resourceName: "logo200703"),#imageLiteral(resourceName: "logo200704"),#imageLiteral(resourceName: "logo200705"),#imageLiteral(resourceName: "logo200706"),#imageLiteral(resourceName: "logo200707"),#imageLiteral(resourceName: "logo200708"),#imageLiteral(resourceName: "logo200709"),#imageLiteral(resourceName: "logo200710"),#imageLiteral(resourceName: "logo200711"),#imageLiteral(resourceName: "logo200712"),#imageLiteral(resourceName: "logo200713"),#imageLiteral(resourceName: "logo200714"),#imageLiteral(resourceName: "logo200715"),#imageLiteral(resourceName: "logo200716"),#imageLiteral(resourceName: "logo200717"),#imageLiteral(resourceName: "logo200718"),#imageLiteral(resourceName: "logo200719"),#imageLiteral(resourceName: "logo200720")]
        maguenAnimatedIcon.animationDuration = 5
    }
        
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if Global.shared.isinSidur {
            return false
        }
        
        if viewController is NewSettingsViewController && !Global.shared.loginOk {
            if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController") {
                tabBarController.present(popUpVC, animated: true)
                //tabBarController.selectedIndex = 4
                return false
                
                //192.168.1.171
            }
        }
        if viewController is CardController && !Global.shared.loginOk {
            if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController") {
                tabBarController.present(popUpVC, animated: true)
                //tabBarController.selectedIndex = 1
                return false
            }
        }
        
        return true
    }
    
    // This delegate open the modal view after open the desired view.
    /*  private func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) -> Bool {
     //print("entre a otro delegado")
     
     let tabBarIndex = tabBarController.selectedIndex
     if tabBarIndex == 0 {
     //print("estoy en 0")
     }
     if tabBarIndex == 1 {
     //print("estoy en 1")
     
     /*   if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController") {
     tabBarController.present(popUpVC, animated: true)
     //tabBarController.selectedIndex = 1
     return false
     }*/
     }
     if tabBarIndex == 2 {
     //print("estoy en 2")
     }
     if tabBarIndex == 3 {
     //print("estoy en 3")
     }
     if tabBarIndex == 4 {
     //print("estoy en 4")
     
     /*  if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController")  {
     tabBarController.present(popUpVC, animated: true)
     //tabBarController.selectedIndex = 4
     return false
     
     //192.168.1.171
     }*/
     }
     return true
     }*/

}
