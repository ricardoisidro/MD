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
        
        let db_centro = Table("centro")
        let db_centro_id = Expression<Int64>("centro_id")
        let db_nombre = Expression<String>("nombre")
        
        let db_eventos = Table("eventos")
        let db_titulo = Expression<String>("titulo")
        let db_fecha_inicial_publicacion = Expression<String>("fecha_inicial_publicacion")
        let db_horario = Expression<String>("horario")
        let db_imagen = Expression<String?>("imagen")
        let db_eliminado = Expression<Int64>("eliminado")
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            let query = db_eventos.select(db_eventos[db_imagen], db_eventos[db_titulo], db_eventos[db_fecha_inicial_publicacion], db_eventos[db_horario], db_centro[db_nombre]).where(db_eventos[db_eliminado] == 0).join(db_centro, on: db_centro[db_centro_id] == db_eventos[db_centro_id])
            guard let queryResults = try? db.prepare(query)
            //guard let queryResults = try? db.prepare("SELECT imagen, titulo, fecha_inicial_publicacion, horario FROM eventos WHERE eliminado = 0")
                else {
                print("ERROR al consultar eventos")
                return
            }
            for row in queryResults {
                let data = eventComponents(eventImage: try row.get(db_imagen)!, eventTitle: try row.get(db_titulo), eventPlace: try row.get(db_nombre), eventDate: try row.get(db_fecha_inicial_publicacion), eventTime: try row.get(db_horario))
                tableViewData.append(data)
            }
            
            /*_ = queryResults.map { row in
                let data = eventComponents(eventImage: row[0]! as! String, eventTitle: row[1] as! String, eventPlace: "", eventDate: row[2] as! String, eventTime: row[3] as! String)
                tableViewData.append(data)
            }*/
            
            
            
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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200.0
        
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let option = indexPath.row
        //print("You tapped cell number \(indexPath.row).")
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "eventdetail", sender: indexPath)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "eventdetail") {
            let next = segue.destination as? EventViewController
            
            next?.eventTitleText = tableViewData[(sender as! NSIndexPath).row].eventTitle
            next?.eventPlaceText = tableViewData[(sender as! NSIndexPath).row].eventPlace
            next?.eventDateText = String(tableViewData[(sender as! NSIndexPath).row].eventDate.prefix(10))
            next?.eventTimeText = tableViewData[(sender as! NSIndexPath).row].eventTime
            next?.eventImageText = tableViewData[(sender as! NSIndexPath).row].eventImage
            
        }
    }

}
