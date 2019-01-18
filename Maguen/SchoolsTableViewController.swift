//
//  SchoolsTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/16/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct schoolComponents {
    var schoolImage: String
    var schoolText = String()
    var schoolPage = String()
}

class SchoolsTableViewController: UITableViewController {

    var tableViewData = [schoolComponents]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*tableViewData = [schoolComponents(schoolImage: #imageLiteral(resourceName: "icon_escuelas"), schoolText: "ATID", schoolPage: "https://www.atid.edu.mx/web/"), schoolComponents(schoolImage: #imageLiteral(resourceName: "icon_escuelas"), schoolText: "Maguén David", schoolPage: "https://www.chmd.edu.mx/"), schoolComponents(schoolImage: #imageLiteral(resourceName: "icon_escuelas"), schoolText: "OR Hajayim", schoolPage: "http://ideurban.com.mx/archivos/536")]*/
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            //tableViewData2 = Array(try db.prepare(users.filter(db_categoria_centro_id == 1)))
            
            guard let queryResults = try? db.prepare("SELECT imagen_portada, nombre, descripcion FROM centro WHERE categoria_centro_id = 2 and eliminado = 0") else {
                //print("ERROR al consultar centro")
                return
            }
            
            _ = queryResults.map { row in
                let data = schoolComponents(schoolImage: row[0] as! String, schoolText: row[1] as! String, schoolPage: row[2] as! String)
                tableViewData.append(data)
            }
            
        }
        catch let ex {
            print("ReadDB error: \(ex)")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "school") as! SchoolCell
        
        let image = UIImage(data: NSData(base64Encoded: tableViewData[indexPath.row].schoolImage)! as Data)
        cell.imgSchool.image = image ?? #imageLiteral(resourceName: "escuela_default")
        cell.imgSchool.layer.cornerRadius = cell.imgSchool.frame.size.width / 2
        cell.imgSchool.clipsToBounds = true
        cell.imgSchool.contentMode = .scaleAspectFill
        cell.txtSchool.text = tableViewData[indexPath.row].schoolText
        
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
        self.performSegue(withIdentifier: "schoolpage", sender: tableViewData[indexPath.row].schoolPage)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "schoolpage") {
            let controller = segue.destination as? SchoolPageViewController
            controller?.schoolURL = (sender as! String)
            
        }
    }
    

}
