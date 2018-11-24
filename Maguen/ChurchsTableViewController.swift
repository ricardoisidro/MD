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
    var churchImage:String
    var churchText:String
}

class ChurchsTableViewController: UITableViewController {

    var tableViewData = [churchsComponents]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Global.shared.createDBFile()
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            //tableViewData2 = Array(try db.prepare(users.filter(db_categoria_centro_id == 1)))
            
            guard let queryResults = try? db.prepare("SELECT imagen_portada, nombre FROM centro WHERE categoria_centro_id = 1 and eliminado = 0") else {
                print("ERROR al consultar centro")
                return
            }
            
            _ = queryResults.map { row in
                let data = churchsComponents(churchImage: row[0] as! String, churchText: row[1] as! String)
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
        // #warning Incomplete implementation, return the number of rows
        return tableViewData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "church") as! ChurchCell
        let image = UIImage(data: NSData(base64Encoded: tableViewData[indexPath.row].churchImage)! as Data)
        cell.imgChurch.image = image ?? #imageLiteral(resourceName: "templo_default")
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
            //controller?.imagenCabecera = segueData.churchImage
            controller?.navigationItem.title = segueData.churchText
            
            
        }
    }
    

}
