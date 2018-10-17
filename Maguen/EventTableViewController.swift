//
//  EventTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/16/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

struct eventComponents {
    var eventImage = UIImage()
    var eventTitle = String()
    var eventPlace = String()
    var eventDate = String()
    var eventTime = String()
}

class EventTableViewController: UITableViewController {

    var tableViewData = [eventComponents]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewData =
            [eventComponents(eventImage: #imageLiteral(resourceName: "evento_cuatro") ,eventTitle: "Bar Mitzva", eventPlace: "Maguén David", eventDate: "22/08/2016", eventTime: "08:00 A.M."),
             eventComponents(eventImage: #imageLiteral(resourceName: "evento_uno") ,eventTitle: "Evento 2", eventPlace: "Maguén David", eventDate: "22/08/2017", eventTime: "09:00 A.M."),
             eventComponents(eventImage: #imageLiteral(resourceName: "evento_dos") ,eventTitle: "Mazel Tov", eventPlace: "Maguén David", eventDate: "22/08/2018", eventTime: "10:00 A.M.")]

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableViewData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "event") as! EventCell
        cell.eventTitle.text = tableViewData[indexPath.row].eventTitle
        cell.eventDate.text = tableViewData[indexPath.row].eventDate
        cell.eventTime.text = tableViewData[indexPath.row].eventTime
        cell.eventPlace.text = tableViewData[indexPath.row].eventPlace
        cell.eventImage.image = tableViewData[indexPath.row].eventImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200.0
        
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let option = indexPath.row
        print("You tapped cell number \(indexPath.row).")
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
