//
//  YouthDetailTableViewController.swift
//  Maguen
//
//  Created by Ricardo Isidro on 10/18/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct cellYouthDetailComponents {
    var opened = Bool()
    var cellImage = UIImage()
    var cellLabel = String()
    var sectionData = [cellYouthSubDetailComponents]()
}

struct cellYouthSubDetailComponents {
    var subLabel = String()
    var subDetail = String()
    var subImage = String()
    var subId = Int()
}

class YouthDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var imgBanner: UIImageView!
    
    var tableViewRootData = [cellYouthDetailComponents]()
    var tableViewDataServices = [cellYouthSubDetailComponents]()
    var tableViewDataEvents = [cellYouthSubDetailComponents]()
    var tableViewDataClasses = [cellYouthSubDetailComponents]()
    var tableViewDataEventDetail = [eventComponents]()
    
    var travelText = ""
    var youthId: Int = 0
    var imagenCabecera: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = imagenCabecera {
            self.imgBanner.image = image
        }
        
        let centro_id = youthId
        
        let db_servicio = Table("servicio")
        let db_servicio_id = Expression<Int64>("servicio_id")
        let db_descripcion = Expression<String>("descripcion")
        let db_imagen = Expression<String?>("imagen")
        let db_eliminado = Expression<Int64>("eliminado")
        
        let db_servicio_centro = Table("servicio_centro")
        let db_centro_id = Expression<Int64>("centro_id")
        let db_clase_id = Expression<Int64>("clase_id")
        
        let db_clases = Table("clases")
        let db_clases_id = Expression<Int64>("clase_id")
        
        let db_eventos = Table("eventos")
        let db_evento_id = Expression<Int64>("evento_id")
        let db_titulo = Expression<String>("titulo")
        let db_fecha_inicial_publicacion = Expression<String>("fecha_inicial_publicacion")
        let db_horario = Expression<String>("horario")
        
        let db_centro = Table("centro")
        let db_nombre = Expression<String>("nombre")
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            let query = db_servicio.select(db_servicio[db_descripcion], db_servicio[db_imagen])
                .join(db_servicio_centro, on: db_servicio_centro[db_servicio_id] == db_servicio[db_servicio_id])
                .where(db_servicio_centro[db_centro_id] == Int64(centro_id))
                .where(db_servicio_centro[db_eliminado] == 0)
            
            guard let queryResults = try? db.prepare(query) else {
                //print("ERROR al consultar servicios JOIN servicio_centro")
                return
            }
            
            for row in queryResults {
                let data = cellYouthSubDetailComponents(subLabel: try row.get(db_descripcion), subDetail: "", subImage: try row.get(db_imagen)!, subId: 0)
                tableViewDataServices.append(data)
            }
            
            // getting classes
            let query2 = db_clases.select(db_clases_id, db_descripcion)
                .where(db_centro_id == Int64(centro_id))
            guard let queryResults2 = try? db.prepare(query2)
                else {
                    //print("ERROR al consultar clases")
                    return
            }
            for row in queryResults2 {
                let data = cellYouthSubDetailComponents(subLabel: try row.get(db_descripcion), subDetail: "", subImage: "", subId: try Int(row.get(db_clase_id)))
                tableViewDataClasses.append(data)
            }
            
            let query3 = db_eventos.select(db_eventos[db_imagen], db_eventos[db_titulo], db_eventos[db_fecha_inicial_publicacion], db_eventos[db_horario], db_eventos[db_evento_id], db_centro[db_nombre]).where(db_eventos[db_eliminado] == 0).where(db_eventos[db_centro_id] == Int64(centro_id)).join(db_centro, on: db_centro[db_centro_id] == db_eventos[db_centro_id])
            guard let queryResults3 = try? db.prepare(query3)
                //guard let queryResults = try? db.prepare("SELECT imagen, titulo, fecha_inicial_publicacion, horario FROM eventos WHERE eliminado = 0")
                else {
                    //print("ERROR al consultar eventos")
                    return
            }
            for row in queryResults3 {
                let fecha = try row.get(db_fecha_inicial_publicacion).prefix(10)
                let hora = try row.get(db_horario)
                let horario = String(fecha) + " " + hora
                let data = eventComponents(eventImage: try row.get(db_imagen)!, eventTitle: try row.get(db_titulo), eventPlace: try row.get(db_nombre), eventDate: try row.get(db_fecha_inicial_publicacion), eventTime: try row.get(db_horario))
                tableViewDataEventDetail.append(data)
                let data2 = cellYouthSubDetailComponents(subLabel: try row.get(db_titulo), subDetail: horario, subImage: "", subId: try Int(row.get(db_evento_id)))
                tableViewDataEvents.append(data2)
            }
            
        }
        catch let ex {
            print("ReadCentroDB in Juventud error: \(ex)")
        }

        tableViewRootData = [
            cellYouthDetailComponents(opened: false, cellImage: #imageLiteral(resourceName: "img_servicios_it"), cellLabel: "Servicios", sectionData: tableViewDataServices), cellYouthDetailComponents(opened: false, cellImage: #imageLiteral(resourceName: "img_eventos_it"), cellLabel: "Eventos", sectionData: tableViewDataEvents), cellYouthDetailComponents(opened: false, cellImage: #imageLiteral(resourceName: "img_escuelas_it"), cellLabel: "Clases", sectionData: tableViewDataClasses)]
        
        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
        self.tableView.backgroundColor = MaguenColors.black1

        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return tableViewRootData.count
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableViewRootData[section].opened == true {
            return tableViewRootData[section].sectionData.count + 1
        }
        else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 { //[0, n]
            let cell = tableView.dequeueReusableCell(withIdentifier: "youthdetailcell") as! YouthDetailCell
            cell.backgroundColor = MaguenColors.black3
            cell.imgYouthDetail.image = tableViewRootData[indexPath.section].cellImage
            cell.txtYouthDetail.text = tableViewRootData[indexPath.section].cellLabel
            //            cell.label.font = UIFont(name: "System Heavy", size:25.0)
            cell.txtYouthDetail.font = UIFont.boldSystemFont(ofSize: 25.0)
            cell.layer.borderWidth = CGFloat(1.0)
            return cell
        }
        else {
            if indexPath.section == 0 { // services
                let cell = tableView.dequeueReusableCell(withIdentifier: "youthdetailchildcell") as! YouthDetailChildCell
                cell.txtYouthDetailChild.text = tableViewDataServices[indexPath.row - 1].subLabel
                //cell.txtChurchDetailChild.text = tableViewData[indexPath.row].sectionData[tableViewData2[indexPath.row - 1].subLabel]
                cell.txtYouthDetailChild.font = UIFont.systemFont(ofSize: 15.0)
                let image = UIImage(data: NSData(base64Encoded: tableViewDataServices[indexPath.row - 1].subImage)! as Data)
                cell.imgYouthDetailChild.image = image ?? #imageLiteral(resourceName: "img_vineta")
                cell.imgYouthDetailChild.layer.cornerRadius = cell.imgYouthDetailChild.frame.size.width / 2
                cell.imgYouthDetailChild.clipsToBounds = true
                
                cell.txtYouthSubDetailChild.text = ""
                cell.txtYouthSubDetailChild.font = UIFont.systemFont(ofSize: 12.0)
                cell.layer.borderWidth = CGFloat(1.0)
                cell.accessoryType = .none
                
                return cell
            }
            else if indexPath.section == 1 { //events
                let cell = tableView.dequeueReusableCell(withIdentifier: "youthdetailchildcell") as! YouthDetailChildCell
                cell.txtYouthDetailChild.text = tableViewDataEvents[indexPath.row - 1].subLabel
                cell.txtYouthDetailChild.font = UIFont.systemFont(ofSize: 15.0)
                cell.imgYouthDetailChild.image = #imageLiteral(resourceName: "img_vineta")
                cell.txtYouthSubDetailChild.text = tableViewDataEvents[indexPath.row - 1].subDetail
                cell.txtYouthSubDetailChild.font = UIFont.systemFont(ofSize: 10.0)
                cell.layer.borderWidth = CGFloat(1.0)
                return cell
            }
            else if indexPath.section == 2 { // classes
                let cell = tableView.dequeueReusableCell(withIdentifier: "youthdetailchildcell") as! YouthDetailChildCell
                cell.txtYouthDetailChild.text = tableViewDataClasses[indexPath.row - 1].subLabel
                //cell.txtChurchDetailChild.text = tableViewData[indexPath.row].sectionData[tableViewData2[indexPath.row - 1].subLabel]
                cell.txtYouthDetailChild.font = UIFont.systemFont(ofSize: 15.0)
                cell.imgYouthDetailChild.image = #imageLiteral(resourceName: "img_vineta")
                cell.txtYouthSubDetailChild.text = ""
                cell.txtYouthSubDetailChild.font = UIFont.systemFont(ofSize: 12.0)
                cell.layer.borderWidth = CGFloat(1.0)
                return cell
            }
            else {
                return YouthDetailChildCell()
            }
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            if tableViewRootData[indexPath.section].opened == true {
                tableViewRootData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
                ////print("Cerrar grupo")
                
            }
            else {
                tableViewRootData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
                ////print("Abriendo grupo")
            }
        }
        else {
            if indexPath.section == 1 { //events
                tableView.deselectRow(at: indexPath, animated: true)
                //travelText = tableViewDataEvents[indexPath.row - 1].subLabel
                ////print("Selected inner cell: " + travelText)
                self.performSegue(withIdentifier: "viewEvent", sender: tableViewDataEventDetail[indexPath.row - 1])
                //travelText = tableView[indexPath.section].sectionData[indexPath.row - 1]
                
            }
            else if indexPath.section == 2 { // classes
                tableView.deselectRow(at: indexPath, animated: true)
                ////print("Selected inner cell: " + travelText)
                self.performSegue(withIdentifier: "viewClass", sender: tableViewDataClasses[indexPath.row - 1])
                
            }
            else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "viewEvent") {
            guard let segueData = sender as? eventComponents
                else { return }
            let controller2 = segue.destination as? EventViewController
            controller2?.eventTitleText = segueData.eventTitle
            controller2?.eventPlaceText = segueData.eventPlace
            controller2?.eventDateText = String(segueData.eventDate.prefix(10))
            controller2?.eventTimeText = segueData.eventTime
            controller2?.eventImageText = segueData.eventImage
        }
        else if(segue.identifier == "viewClass") {
            guard let segueData = sender as? cellYouthSubDetailComponents else {
                return
            }
            let controller3 = segue.destination as? ChurchClassDetailViewController
            controller3?.id = segueData.subId
            controller3?.txtMyTitle = segueData.subLabel
            
            
        }
    }



}
