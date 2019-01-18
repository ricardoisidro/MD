//
//  CommitteeTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/16/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct committeeComponents {
    var committeeTitle = String()
    var committeePhone = String()
}

class CommitteeTableViewController: UITableViewController {
    
    var tableViewData = [committeeComponents]()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            guard let queryResults = try? db.prepare("SELECT nombre_comite, telefono FROM comites WHERE eliminado = 0") else {
                //print("ERROR al consultar Comites")
                return
            }
            
            _ = queryResults.map { row in
                let data = committeeComponents(committeeTitle: row[0] as! String, committeePhone: row[1] as! String)
                tableViewData.append(data)
            }
            
        }
        catch let ex {
            print("ReadCentroDB in Templos error: \(ex)")
        }
        
        /*tableViewData = [
            committeeComponents(committeeImage: #imageLiteral(resourceName: "img_jebrakadisha"), committeeTitle: "Comité 1", committeePhone: "5557575757"),
            committeeComponents(committeeImage: #imageLiteral(resourceName: "img_jebrakadisha"), committeeTitle: "Comité 2", committeePhone: "5556565656")]*/
        
        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
        self.tableView.backgroundColor = MaguenColors.black1

        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableViewData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "committee") as! CommitteeCell
        
        //cell.imgCommittee.image = tableViewData[indexPath.row].committeeImage
        cell.imgCommittee.image = #imageLiteral(resourceName: "img_jebrakadisha")
        cell.imgCommittee.layer.cornerRadius = cell.imgCommittee.frame.size.width / 2
        cell.imgCommittee.clipsToBounds = true
        cell.txtCommittee.text = tableViewData[indexPath.row].committeeTitle
        cell.phoneCommittee.text = tableViewData[indexPath.row].committeePhone
        
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
        ////print("You tapped cell number \(indexPath.row).")
        tableView.deselectRow(at: indexPath, animated: true)
        let number = tableViewData[indexPath.row].committeePhone
        let url:NSURL = NSURL(string: "tel://" + number)!
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
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
