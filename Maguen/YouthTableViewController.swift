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
    var youthId = Int()
}

class YouthTableViewController: UITableViewController {
    
    let db_centro = Table("centro")
    let db_centro_id = Expression<Int64>("centro_id")
    let db_imagen_portada = Expression<String>("imagen_portada")
    let db_nombre = Expression<String>("nombre")
    let db_categoria_centro_id = Expression<Int64>("categoria_centro_id")
    let db_eliminado = Expression<Int64>("eliminado")
    
    var tableViewData = [youthComponents]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            let query = db_centro.select(db_centro[db_imagen_portada], db_centro[db_nombre], db_centro[db_centro_id]).where(db_centro[db_categoria_centro_id] == 3).where(db_centro[db_eliminado] == 0)
            guard let queryResults = try? db.prepare(query) else {
                //print("ERROR al consultar centro")
                return
            }
            
            for row in queryResults {
                let data = youthComponents(youthImage: try row.get(db_imagen_portada), youthText: try row.get(db_nombre), youthId: try Int(row.get(db_centro_id)))
                
                tableViewData.append(data)
            }
        }
        catch let ex {
            print("ReadCentroDB in Juventud error: \(ex)")
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
        cell.imgYouth.contentMode = .scaleAspectFill

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
        ////print("You tapped cell number \(indexPath.row).")
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "youthdetail", sender: tableViewData[indexPath.row])
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
        guard let segueData = sender as? youthComponents
            else { return }
        if(segue.identifier == "youthdetail") {
            let controller = segue.destination as? YouthDetailTableViewController
            controller?.navigationItem.title = segueData.youthText
            controller?.youthId = segueData.youthId
            
            let image = UIImage(data: NSData(base64Encoded: segueData.youthImage)! as Data)
            controller?.imagenCabecera = image
        }
        
    }
    

}
