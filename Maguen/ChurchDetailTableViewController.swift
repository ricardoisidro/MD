//
//  ChurchDetailTableViewController.swift
//  Maguen
//
//  Created by Ricardo Isidro on 10/18/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

struct cellChurchDetailComponents {
    var opened = Bool()
    var cellIcon = UIImage()
    var cellTitle = String()
    var sectionData = [String]()
}

var travelText = ""

class ChurchDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var imgBanner: UIImageView!
    
    var imagenCabecera: UIImage?
    
    var tableViewData = [cellChurchDetailComponents]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = imagenCabecera {
            self.imgBanner.image = image
        }

        tableViewData = [
            cellChurchDetailComponents(opened: false, cellIcon: #imageLiteral(resourceName: "img_itinerario_it"), cellTitle: "Itinerario", sectionData: ["Lunes-Viernes", "Sabado", "Domingo"]),
            cellChurchDetailComponents(opened: false, cellIcon: #imageLiteral(resourceName: "img_servicios_it"), cellTitle: "Servicios", sectionData: ["Bartmitzvah", "Tebilá Hombres", "Servicio 3"]),
            cellChurchDetailComponents(opened: false, cellIcon: #imageLiteral(resourceName: "img_eventos_it"), cellTitle: "Eventos", sectionData: ["Bartmitzvah", "Evento de prueba", "Evento prueba 3"]),
            cellChurchDetailComponents(opened: false, cellIcon: #imageLiteral(resourceName: "img_escuelas_it"), cellTitle: "Clases", sectionData: ["Daff Hayomi", "Halajot y Perasha"])]

        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
        self.tableView.backgroundColor = MaguenColors.black1

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return tableViewData.count
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableViewData[section].opened == true {
            return tableViewData[section].sectionData.count + 1
        }
        else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "churchdetailcell") as! ChurchDetailTableViewCell
            cell.backgroundColor = UIColor.darkGray
            cell.imgChurchDetail.image = tableViewData[indexPath.section].cellIcon
            cell.txtChurchDetail.text = tableViewData[indexPath.section].cellTitle
            //            cell.label.font = UIFont(name: "System Heavy", size:25.0)
            cell.txtChurchDetail.font = UIFont.boldSystemFont(ofSize: 25.0)
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "churchdetailchildcell") as! ChurchDetailChildCell
            cell.txtChurchDetailChild.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            cell.txtChurchDetailChild.font = UIFont.systemFont(ofSize: 15.0)
            cell.imgChurchDetailChild.image = #imageLiteral(resourceName: "img_vineta")
            cell.txtSubChurchDetailChild.text = ""
            cell.txtSubChurchDetailChild.font = UIFont.systemFont(ofSize: 12.0)
            return cell
            
        }
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
                print("Cerrar grupo")
                
            }
            else {
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
                print("Abriendo grupo")
            }
        }
        else {
            travelText = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            print("Selected inner cell: " + travelText)
            tableView.deselectRow(at: indexPath, animated: true)
            /*let nextVC = RegisterProviderController()
             nextVC.customInit(title: text)
             theTableView.deselectRow(at: indexPath, animated: true)
             self.navigationController?.pushViewController(nextVC, animated: true)
             */
        }
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
