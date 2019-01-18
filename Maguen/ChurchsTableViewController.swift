//
//  ChurchsTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/15/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct churchsComponents {
    var churchImage = String()
    var churchText = String()
    var churchId = Int()
}

class ChurchsTableViewController: UITableViewController {

    var tableViewData = [churchsComponents]()
    
    let db_centro = Table("centro")
    let db_centro_id = Expression<Int64>("centro_id")
    let db_imagen_portada = Expression<String>("imagen_portada")
    let db_nombre = Expression<String>("nombre")
    let db_categoria_centro_id = Expression<Int64>("categoria_centro_id")
    let db_eliminado = Expression<Int64>("eliminado")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            //tableViewData2 = Array(try db.prepare(users.filter(db_categoria_centro_id == 1)))
            let query = db_centro.select(db_centro[db_imagen_portada], db_centro[db_nombre], db_centro[db_centro_id]).where(db_centro[db_categoria_centro_id] == 1).where(db_centro[db_eliminado] == 0)
            //guard let queryResults = try? db.prepare("SELECT imagen_portada, nombre, centro_id FROM centro WHERE categoria_centro_id = 1 and eliminado = 0") else {
            guard let queryResults = try? db.prepare(query) else {
                //print("ERROR al consultar centro")
                return
            }
            
            for row in queryResults {
                let data = churchsComponents(churchImage: try row.get(db_imagen_portada), churchText: try row.get(db_nombre), churchId: try Int(row.get(db_centro_id)))
                tableViewData.append(data)
            }
            
            /*_ = queryResults.map { row in
                let data = churchsComponents(churchImage: row[0] as! String, churchText: row[1] as! String, churchId: row[2] as! Int)
                tableViewData.append(data)
            }*/
            
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
        // #warning Incomplete implementation, return the number of rows
        return tableViewData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "church") as! ChurchCell
        let image = UIImage(data: NSData(base64Encoded: tableViewData[indexPath.row].churchImage)! as Data)
        cell.imgChurch.image = image ?? #imageLiteral(resourceName: "templo_default")
        cell.imgChurch.contentMode = .scaleAspectFill
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
        ////print("You tapped cell number \(indexPath.row).")
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
            //controller?.imagenCabecera = segueData.churchImage
            controller?.navigationItem.title = segueData.churchText
            let image = UIImage(data: NSData(base64Encoded: segueData.churchImage)! as Data)
            controller?.imagenCabecera = image
            controller?.churchId = segueData.churchId
        
            
        }
    }
    

}
