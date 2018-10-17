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
            [churchsComponents(churchImage: #imageLiteral(resourceName: "foto_maguen") ,churchText: "Maguen David"),
             churchsComponents(churchImage: #imageLiteral(resourceName: "foto_maguen"), churchText: "Eliahu Fasja"),
             churchsComponents(churchImage: #imageLiteral(resourceName: "foto_maguen"), churchText: "Shaare Tefila"),
             churchsComponents(churchImage: #imageLiteral(resourceName: "foto_maguen"), churchText: "Shaarem Shallom")]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
