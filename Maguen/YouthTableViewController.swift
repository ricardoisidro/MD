//
//  YouthTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/16/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct youthComponents {
    var youthImage = String()
    var youthText = String()
}

class YouthTableViewController: UITableViewController {
    
    var tableViewData = [youthComponents]()

    override func viewDidLoad() {
        super.viewDidLoad()

        //tableViewData = [youthComponents(youthImage: #imageLiteral(resourceName: "evento_cuatro"), youthText: "Talmud Torah"), youthComponents(youthImage: #imageLiteral(resourceName: "evento_cuatro"), youthText: "Nuevo grupo")]
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            guard let queryResults = try? db.prepare("SELECT imagen_portada, nombre FROM centro WHERE categoria_centro_id = 3 and eliminado = 0") else {
                print("ERROR al consultar Juventud")
                return
            }
            
            _ = queryResults.map { row in
                let data = youthComponents(youthImage: row[0] as! String, youthText: row[1] as! String)
                tableViewData.append(data)
            }
            
        }
        catch let ex {
            print("ReadCentroDB in Templos error: \(ex)")
        }
        
        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
        self.tableView.backgroundColor = MaguenColors.black1

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "youth") as! YouthCell
        
        let image = UIImage(data: NSData(base64Encoded: tableViewData[indexPath.row].youthImage)! as Data)
        cell.imgYouth.image = image ?? #imageLiteral(resourceName: "comunidad_default")
        cell.imgYouth.layer.cornerRadius = cell.imgYouth.frame.size.width / 2
        cell.imgYouth.clipsToBounds = true
        cell.txtYouth.text = tableViewData[indexPath.row].youthText
        
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
        self.performSegue(withIdentifier: "youthdetail", sender: tableViewData[indexPath.row].youthText)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "youthdetail") {
            let controller = segue.destination as? YouthDetailTableViewController
            controller?.navigationItem.title = (sender as! String)
        }
        
    }
    

}
