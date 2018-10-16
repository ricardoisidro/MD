//
//  MediaTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/15/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

struct mediaComponents {
    var mediaImage = UIImage()
    var mediaText = String()
    var mediaDate = String()
}

class MediaTableViewController: UITableViewController {

    var tableViewData = [mediaComponents]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewData =
            [mediaComponents(mediaImage: #imageLiteral(resourceName: "img_canal") ,mediaText: "Maguen Media", mediaDate: ""),
             mediaComponents(mediaImage: #imageLiteral(resourceName: "img_periodico"), mediaText: "Periódico", mediaDate: "24/abril/2018"),
             mediaComponents(mediaImage: #imageLiteral(resourceName: "img_revista"), mediaText: "Revista", mediaDate: "24/abril/2018"),
             mediaComponents(mediaImage: #imageLiteral(resourceName: "img_facebook"), mediaText: "Facebook", mediaDate: ""),
             mediaComponents(mediaImage: #imageLiteral(resourceName: "img_instagram"), mediaText: "Instagram", mediaDate: "")
        ]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "media") as! MediaCell
        
        cell.imgMedia.image = tableViewData[indexPath.row].mediaImage
        cell.imgMedia.layer.cornerRadius = cell.imgMedia.frame.size.width / 2
        cell.imgMedia.clipsToBounds = true
        cell.textMedia.text = tableViewData[indexPath.row].mediaText
        cell.dateMedia.text = tableViewData[indexPath.row].mediaDate
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
        
    }
    
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
