//
//  ChurchsTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/15/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

struct churchsComponents {
    var churchImage = UIImage()
    var churchText = String()
}

class ChurchsTableViewController: UITableViewController {

    var tableViewData = [churchsComponents]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewData =
            [churchsComponents(churchImage: #imageLiteral(resourceName: "banner_maguen") ,churchText: "Maguen David"),
             churchsComponents(churchImage: #imageLiteral(resourceName: "evento_dos"), churchText: "Eliahu Fasja"),
             churchsComponents(churchImage: #imageLiteral(resourceName: "evento_uno"), churchText: "Shaare Tefila"),
             churchsComponents(churchImage: #imageLiteral(resourceName: "evento_cuatro"), churchText: "Shaarem Shallom")]

        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableViewData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "church") as! ChurchCell

        cell.imgChurch.image = tableViewData[indexPath.row].churchImage
        cell.imgChurch.layer.cornerRadius = cell.imgChurch.frame.size.width / 2
        cell.imgChurch.clipsToBounds = true
        cell.txtChurch.text = tableViewData[indexPath.row].churchText
        
        cell.layer.borderWidth = CGFloat(5.0)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
        
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let option = indexPath.row
        print("You tapped cell number \(indexPath.row).")
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "churchdetail", sender: tableViewData[indexPath.row])
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueData = sender as? churchsComponents
            else { return }
        if(segue.identifier == "churchdetail") {
            let controller = segue.destination as? ChurchDetailTableViewController
            //controller?.navigationItem.title = (sender as! String)
            controller?.imagenCabecera = segueData.churchImage
            controller?.navigationItem.title = segueData.churchText
            
            
        }
    }
    

}
