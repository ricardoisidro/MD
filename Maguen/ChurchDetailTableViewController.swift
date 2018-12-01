//
//  ChurchDetailTableViewController.swift
//  Maguen
//
//  Created by Ricardo Isidro on 10/18/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct cellChurchDetailComponents {
    var opened = Bool()
    var cellIcon = UIImage()
    var cellTitle = String()
    var sectionData = [cellChurchSubDetailComponents]()
}

struct cellChurchSubDetailComponents {
    var subLabel = String()
    var subDetail = String()
    var subImage = String()
    var subId = Int()
}

class ChurchDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var imgBanner: UIImageView!
    
    var tableViewRootData = [cellChurchDetailComponents]()
    var tableViewDataItinerary = [cellChurchSubDetailComponents]()
    var tableViewDataServices = [cellChurchSubDetailComponents]()
    var tableViewDataEvents = [cellChurchSubDetailComponents]()
    var tableViewDataClasses = [cellChurchSubDetailComponents]()
    
    var travelText = ""
    var churchId: Int = 0
    var imagenCabecera: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = imagenCabecera {
            self.imgBanner.image = image
        }
        let centro_id = churchId
        
        let db_servicio = Table("servicio")
        let db_servicio_id = Expression<Int64>("servicio_id")
        let db_descripcion = Expression<String>("descripcion")
        let db_imagen = Expression<String?>("imagen")
        let db_eliminado = Expression<Int64>("eliminado")
        
        let db_servicio_centro = Table("servicio_centro")
        let db_centro_id = Expression<Int64>("centro_id")

        let db_horario_clase = Table("horario_clase")
        let db_horario_clase_id = Expression<Int64>("horario_clase")
        let db_clase_id = Expression<Int64>("clase_id")
        let db_profesor = Expression<String>("profesor")
        let db_dias = Expression<String>("dias")
        //let db_horario = Expression<String>("horario")
        //let db_eliminado = Expression<Int64>("eliminado")
        //let db_fecha_modificacion = Expression<String>("fecha_modificacion")
        
        let db_clases = Table("clases")
        let db_clases_id = Expression<Int64>("clase_id")
        //let db_descripcion = Expression<String>("descripcion")
        //var db_centro_id = Expression<Int64>("centro_id")
        
        let db_eventos = Table("eventos")
        let db_evento_id = Expression<Int64>("evento_id")
        //let db_centro_id = Expression<Int64>("centro_id")
        let db_titulo = Expression<String>("titulo")
        let db_fecha_inicial_publicacion = Expression<String>("fecha_inicial_publicacion")
        let db_fecha_final_publicacion = Expression<String>("fecha_final_publicacion")
        let db_horario = Expression<String>("horario")
        //let db_imagen = Expression<String?>("imagen")
        //let db_eliminado = Expression<Int64>("eliminado")
        //let db_fecha_modificacion = Expression<String>("fecha_modificacion")

        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            //let query = db_eventos.select(db_imagen, db_titulo, db_fecha_inicial_publicacion, db_horario).where(db_eliminado == 0)
            //let query2 = db_eventos.join(db_centro, on: db_centro[db_centro_id] == db_eventos[db_centro_id])
            let query = db_servicio.select(db_servicio[db_descripcion], db_servicio[db_imagen])
                .join(db_servicio_centro, on: db_servicio_centro[db_servicio_id] == db_servicio[db_servicio_id])
                .where(db_servicio_centro[db_centro_id] == Int64(centro_id))
                .where(db_servicio_centro[db_eliminado] == 0)
            
            guard let queryResults = try? db.prepare(query)
                else {
                    print("ERROR al consultar servicios join servicio_centro")
                    return
            }
            for row in queryResults {
                let data = cellChurchSubDetailComponents(subLabel: try row.get(db_descripcion), subDetail: "", subImage: try row.get(db_imagen)!, subId: 0)
                tableViewDataServices.append(data)
            }
            
            let query2 = db_clases.select(db_clases_id, db_descripcion)
                .where(db_centro_id == Int64(centro_id))
            guard let queryResults2 = try? db.prepare(query2)
                else {
                    print("ERROR al consultar servicios join servicio_centro")
                    return
            }
            for row in queryResults2 {
                let data = cellChurchSubDetailComponents(subLabel: try row.get(db_descripcion), subDetail: "", subImage: "", subId: try Int(row.get(db_clase_id)))
                tableViewDataClasses.append(data)
            }
            
            let query3 = db_eventos.select(db_evento_id, db_titulo, db_fecha_inicial_publicacion, db_horario)
                .where(db_centro_id == Int64(centro_id))
            
            guard let queryResults3 = try? db.prepare(query3)
                else {
                    print("ERROR al consultar servicios join servicio_centro")
                    return
            }
            for row in queryResults3 {
                let fecha = try row.get(db_fecha_inicial_publicacion).prefix(10)
                let hora = try row.get(db_horario)
                let horario = String(fecha) + " " + hora
                let data = cellChurchSubDetailComponents(subLabel: try row.get(db_titulo), subDetail: horario, subImage: "", subId: try Int(row.get(db_evento_id)))
                tableViewDataEvents.append(data)
            }
        }
        catch let ex {
            print("ReadDB error: \(ex)")
        }
        
        tableViewDataItinerary = [cellChurchSubDetailComponents(subLabel: "Lunes-Viernes", subDetail: "", subImage: "", subId: 0),
                                  cellChurchSubDetailComponents(subLabel: "Sábado", subDetail: "", subImage: "", subId: 0),
                                  cellChurchSubDetailComponents(subLabel: "Domingo", subDetail: "", subImage: "", subId: 0)]
        
        
        tableViewRootData = [
            cellChurchDetailComponents(opened: false, cellIcon: #imageLiteral(resourceName: "img_itinerario_it"), cellTitle: "Itinerario", sectionData: tableViewDataItinerary),
            cellChurchDetailComponents(opened: false, cellIcon: #imageLiteral(resourceName: "img_servicios_it"), cellTitle: "Servicios", sectionData: tableViewDataServices),
            cellChurchDetailComponents(opened: false, cellIcon: #imageLiteral(resourceName: "img_eventos_it"), cellTitle: "Eventos", sectionData: tableViewDataEvents),
            cellChurchDetailComponents(opened: false, cellIcon: #imageLiteral(resourceName: "img_escuelas_it"), cellTitle: "Clases", sectionData: tableViewDataClasses)]

        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
        self.tableView.backgroundColor = MaguenColors.black1

    }

    // MARK: - Table view data source

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
            let cell = tableView.dequeueReusableCell(withIdentifier: "churchdetailcell") as! ChurchDetailTableViewCell
            cell.backgroundColor = MaguenColors.black3
            cell.imgChurchDetail.image = tableViewRootData[indexPath.section].cellIcon
            cell.txtChurchDetail.text = tableViewRootData[indexPath.section].cellTitle
            //            cell.label.font = UIFont(name: "System Heavy", size:25.0)
            cell.txtChurchDetail.font = UIFont.boldSystemFont(ofSize: 25.0)
            cell.layer.borderWidth = CGFloat(1.0)
            return cell
        }
        else {
            if indexPath.section == 0 { // itinerary
                let cell = tableView.dequeueReusableCell(withIdentifier: "churchdetailchildcell") as! ChurchDetailChildCell
                cell.txtChurchDetailChild.text = tableViewDataItinerary[indexPath.row - 1].subLabel
                //cell.txtChurchDetailChild.text = tableViewData[indexPath.row].sectionData[tableViewData2[indexPath.row - 1].subLabel]
                cell.txtChurchDetailChild.font = UIFont.systemFont(ofSize: 15.0)
                cell.imgChurchDetailChild.image = #imageLiteral(resourceName: "img_vineta")
                cell.txtSubChurchDetailChild.text = ""
                cell.txtSubChurchDetailChild.font = UIFont.systemFont(ofSize: 12.0)
                cell.layer.borderWidth = CGFloat(1.0)
                cell.accessoryType = .disclosureIndicator

                return cell
            }
            else if indexPath.section == 1 { // services
                let cell = tableView.dequeueReusableCell(withIdentifier: "churchdetailchildcell") as! ChurchDetailChildCell
                cell.txtChurchDetailChild.text = tableViewDataServices[indexPath.row - 1].subLabel
                //cell.txtChurchDetailChild.text = tableViewData[indexPath.row].sectionData[tableViewData2[indexPath.row - 1].subLabel]
                cell.txtChurchDetailChild.font = UIFont.systemFont(ofSize: 15.0)
                let image = UIImage(data: NSData(base64Encoded: tableViewDataServices[indexPath.row - 1].subImage)! as Data)
                cell.imgChurchDetailChild.image = image ?? #imageLiteral(resourceName: "img_vineta")
                cell.imgChurchDetailChild.layer.cornerRadius = cell.imgChurchDetailChild.frame.size.width / 2
                cell.imgChurchDetailChild.clipsToBounds = true
                
                cell.txtSubChurchDetailChild.text = ""
                cell.txtSubChurchDetailChild.font = UIFont.systemFont(ofSize: 12.0)
                cell.layer.borderWidth = CGFloat(1.0)
                cell.accessoryType = .none

                return cell
            }
            else if indexPath.section == 3 { // classes
                let cell = tableView.dequeueReusableCell(withIdentifier: "churchdetailchildcell") as! ChurchDetailChildCell
                cell.txtChurchDetailChild.text = tableViewDataClasses[indexPath.row - 1].subLabel
                //cell.txtChurchDetailChild.text = tableViewData[indexPath.row].sectionData[tableViewData2[indexPath.row - 1].subLabel]
                cell.txtChurchDetailChild.font = UIFont.systemFont(ofSize: 15.0)
                cell.imgChurchDetailChild.image = #imageLiteral(resourceName: "img_vineta")
                cell.txtSubChurchDetailChild.text = ""
                cell.txtSubChurchDetailChild.font = UIFont.systemFont(ofSize: 12.0)
                cell.layer.borderWidth = CGFloat(1.0)
                return cell
            }
            else if indexPath.section == 2 { //events
                let cell = tableView.dequeueReusableCell(withIdentifier: "churchdetailchildcell") as! ChurchDetailChildCell
                cell.txtChurchDetailChild.text = tableViewDataEvents[indexPath.row - 1].subLabel
                cell.txtChurchDetailChild.font = UIFont.systemFont(ofSize: 15.0)
                cell.imgChurchDetailChild.image = #imageLiteral(resourceName: "img_vineta")
                cell.txtSubChurchDetailChild.text = tableViewDataEvents[indexPath.row - 1].subDetail
                cell.txtSubChurchDetailChild.font = UIFont.systemFont(ofSize: 10.0)
                cell.layer.borderWidth = CGFloat(1.0)
                return cell
            }
            else {
                return ChurchDetailChildCell()
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
                print("Cerrar grupo")
                
            }
            else {
                tableViewRootData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
                print("Abriendo grupo")
            }
        }
        else {
            //travelText = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            //print("Selected inner cell: " + travelText)
            tableView.deselectRow(at: indexPath, animated: true)
            self.performSegue(withIdentifier: "checkPrays", sender: travelText)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "checkPrays") {
            let controller = segue.destination as? ChurchPrayDetailViewController
            controller?.txtTitle = (sender as! String)
            
        }
    }

}
