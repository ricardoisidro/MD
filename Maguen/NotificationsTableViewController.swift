//
//  NotificationsTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/15/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

struct notificationsComponents {
    var notificationTitle = String()
    var notificationDate = String()
    var notificationText = String()
}

class NotificationsTableViewController: UITableViewController {
    
    var tableViewData = [notificationsComponents]()

    @IBOutlet var notificationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewData =
            [notificationsComponents(notificationTitle: "Centro Maguén", notificationDate: "19/09/18 10:40", notificationText: "Estimada comunidad, son todos bienvenidos a la fiesta..."),
             notificationsComponents(notificationTitle: "Centro Maguén", notificationDate: "18/09/18 10:40", notificationText: "Estimada comunidad, son todos bienvenidos a la fiesta que se llevará a cabo este fin de semana por la mañana, acompañando a nuestro amigo el Sr Toffy"),
             notificationsComponents(notificationTitle: "Centro Maguén", notificationDate: "17/09/18 10:40", notificationText: "Estimada comunidad, son tod@s bienvenidos a la fiesta...")]

        self.tableView.backgroundColor = MaguenColors.black1
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tableViewData.count > 0
        {
            self.tabBarItem.badgeValue = String(tableViewData.count)
            self.tabBarItem.badgeColor = .red
        }
        else {
            self.tabBarItem.badgeValue = nil
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if tableViewData.count > 0
        {
            self.tabBarItem.badgeValue = String(tableViewData.count)
            self.tabBarItem.badgeColor = .red
        }
        else {
            self.tabBarItem.badgeValue = nil
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableViewData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationsTableView.dequeueReusableCell(withIdentifier: "notification") as! NotificationCell
        cell.notificationTitle.text = tableViewData[indexPath.row].notificationTitle
        cell.notificationTitle.font = UIFont.boldSystemFont(ofSize: 13.0)
        cell.notificationDate.text = tableViewData[indexPath.row].notificationDate
        cell.notificationDate.font = UIFont.systemFont(ofSize: 12.0)
        cell.notificationText.text = tableViewData[indexPath.row].notificationText
        cell.notificationText.font = UIFont.boldSystemFont(ofSize: 15.0)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableViewData.remove(at: indexPath.item)
            notificationsTableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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
