//
//  EventTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/16/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct eventComponents {
    var eventImage = String()
    var eventTitle = String()
    var eventPlace = String()
    var eventDate = String()
    var eventTime = String()
}

class EventTableViewController: UITableViewController {

    var tableViewData = [eventComponents]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*tableViewData =
            [eventComponents(eventImage: #imageLiteral(resourceName: "evento_cuatro") ,eventTitle: "Bar Mitzva", eventPlace: "Maguén David", eventDate: "22/08/2016", eventTime: "08:00 A.M."),
             eventComponents(eventImage: #imageLiteral(resourceName: "evento_uno") ,eventTitle: "Evento 2", eventPlace: "Maguén David", eventDate: "22/08/2017", eventTime: "09:00 A.M."),
             eventComponents(eventImage: #imageLiteral(resourceName: "evento_dos") ,eventTitle: "Mazel Tov", eventPlace: "Maguén David", eventDate: "22/08/2018", eventTime: "10:00 A.M.")]*/
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            //tableViewData2 = Array(try db.prepare(users.filter(db_categoria_centro_id == 1)))
            
            guard let queryResults = try? db.prepare("SELECT imagen, titulo, fecha_inicial_publicacion, horario FROM eventos WHERE eliminado = 0") else {
                print("ERROR al consultar eventos")
                return
            }
            
            _ = queryResults.map { row in
                let data = eventComponents(eventImage: row[0] as! String, eventTitle: row[1] as! String, eventPlace: "", eventDate: row[2] as! String, eventTime: row[3] as! String)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "event") as! EventCell
        cell.eventTitle.text = tableViewData[indexPath.row].eventTitle
        let fecha = String(tableViewData[indexPath.row].eventDate.prefix(10))
        cell.eventDate.text = fecha
        cell.eventTime.text = tableViewData[indexPath.row].eventTime
        cell.eventPlace.text = tableViewData[indexPath.row].eventPlace
        let url = MaguenCredentials.urlEventImages + tableViewData[indexPath.row].eventImage + ".jpg"
        if let cad = URL(string: url) {
            if let data = NSData(contentsOf: cad) {
                cell.eventImage.image = UIImage(data: data as Data)
            }
        }
        //let image = UIImage(data: NSData(base64Encoded: tableViewData[indexPath.row].eventImage)! as Data) ?? #imageLiteral(resourceName: "evento_cuatro")
        //cell.eventImage.image = image
        //cell.eventImage.image = #imageLiteral(resourceName: "evento_cuatro")
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
        self.performSegue(withIdentifier: "eventdetail", sender: tableViewData[indexPath.row].eventTitle)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "eventdetail") {
            _ = segue.destination as? EventViewController
            //controller? = (sender as! String)
            
        }
    }

}
