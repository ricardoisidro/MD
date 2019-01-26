//
//  SidurTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/11/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct sidurComponents {
    var sidurImage = UIImage()
    var sidurText = String()
}

class SidurTableViewController: UITableViewController {

    
    var tableViewData = [sidurComponents]()
   
    var sidurTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewData =
            [sidurComponents(sidurImage: #imageLiteral(resourceName: "sidur_default") ,sidurText: "Arbit"),
             sidurComponents(sidurImage: #imageLiteral(resourceName: "sidur_default"), sidurText: "Omer"),
             sidurComponents(sidurImage: #imageLiteral(resourceName: "sidur_default"), sidurText: "Minja"),
             sidurComponents(sidurImage: #imageLiteral(resourceName: "sidur_default"), sidurText: "Tefilat"),
             sidurComponents(sidurImage: #imageLiteral(resourceName: "sidur_default"), sidurText: "Refua")
        ]
        
        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
        self.tableView.backgroundColor = MaguenColors.black1
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sidur") as! SidurCell
        
        cell.imgSidur.image = tableViewData[indexPath.row].sidurImage
        cell.imgSidur.layer.cornerRadius = cell.imgSidur.frame.size.width / 2
        cell.imgSidur.clipsToBounds = true
        cell.imgSidur.contentMode = .scaleAspectFill
        cell.textSidur.text = tableViewData[indexPath.row].sidurText
      
        
        cell.layer.borderWidth = CGFloat(5.0)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let option = indexPath.row
        ////print("You tapped cell number \(indexPath.row).")
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "Arbit", sender: tableViewData[indexPath.row].sidurText)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */



 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueData = sender as? String
            else { return }
       
        let controller = segue.destination as? SidurPageViewController
        
        controller?.tipoRezo = segueData
        controller?.navigationItem.title = segueData
        
    }
 

}
