//
//  YouthDetailTableViewController.swift
//  Maguen
//
//  Created by Ricardo Isidro on 10/18/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

struct cellYouthDetailComponents {
    var opened = Bool()
    var cellImage = UIImage()
    var cellLabel = String()
}

class YouthDetailTableViewController: UITableViewController {
    
    var tableViewData = [cellYouthDetailComponents]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewData = [cellYouthDetailComponents(opened: false, cellImage: #imageLiteral(resourceName: "img_servicios_it"), cellLabel: "Servicios"), cellYouthDetailComponents(opened: false, cellImage: #imageLiteral(resourceName: "img_eventos_it"), cellLabel: "Eventos"), cellYouthDetailComponents(opened: false, cellImage: #imageLiteral(resourceName: "img_escuelas_it"), cellLabel: "Clases")]
        
        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
    self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
        self.tableView.backgroundColor = MaguenColors.black1

        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return tableViewData.count
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableViewData[section].opened == true {
            //return tableViewData[section].sectionData.count + 1
            return 1
        }
        else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "youthdetailcell") as! YouthDetailCell
            cell.imgYouthDetail.image = tableViewData[indexPath.section].cellImage
            cell.backgroundColor = MaguenColors.black3
            cell.txtYouthDetail.text = tableViewData[indexPath.section].cellLabel
            cell.txtYouthDetail.font = UIFont.boldSystemFont(ofSize: 17.0)
            cell.layer.borderWidth = CGFloat(1.0)
            return cell
        }
        else {
            return UITableViewCell()
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        /*if indexPath.row == 0 {
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
        }*/
    }



}
