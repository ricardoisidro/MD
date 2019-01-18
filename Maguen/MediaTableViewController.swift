//
//  MediaTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/15/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct mediaComponents {
    var mediaImage = UIImage()
    var mediaText = String()
    var mediaAuxText = String()
}

class MediaTableViewController: UITableViewController {

    var tableViewData = [mediaComponents]()
    var seguesIdentifiers = ["Youtube", "Periodico", "Revista", "Facebook", "Instagram","HistPeriodico","HistRevista"]
    var dailyTitle: String = ""
    var magazineTitle: String = ""

    let db_publicacion = Table("publicacion")
    let db_publicacion_id = Expression<Int64>("publicacion_id")
    let db_descripcion = Expression<String>("descripcion")
    let db_fecha_inicial_publicacion = Expression<Date>("fecha_inicial_publicacion")
    let db_categoria_publicacion_id = Expression<Int64>("categoria_publicacion_id")
    let db_paginas = Expression<Int64>("paginas")
    let db_eliminado = Expression<Int64>("eliminado")
    let db_fecha_modificacion = Expression<String>("fecha_modificacion")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            // where categoria publicacion id = 1 (1 periodico; 2 revista)
            let query1 = db_publicacion.select(db_descripcion).order(db_fecha_inicial_publicacion.date.desc).where(db_categoria_publicacion_id == 1).where(db_eliminado == 0)
            let currentDaily = try db.pluck(query1)
            
            let query2 = db_publicacion.select(db_descripcion).order(db_fecha_inicial_publicacion.date.desc).where(db_categoria_publicacion_id == 2).where(db_eliminado == 0)
            let currentMagazine = try db.pluck(query2)
            
            dailyTitle = try currentDaily?.get(db_descripcion) ?? ""
            ////print(dailyTitle!)
            
            magazineTitle = try currentMagazine?.get(db_descripcion) ?? ""
            ////print(magazineTitle!)
            
            
        }
        catch let err {
            print("Read publicacionDB error: \(err)")
            
        }

        tableViewData =
            [mediaComponents(mediaImage: #imageLiteral(resourceName: "img_canal") ,mediaText: "Maguén Media", mediaAuxText: ""),
             mediaComponents(mediaImage: #imageLiteral(resourceName: "img_periodico"), mediaText: "Periódico", mediaAuxText: dailyTitle),
             mediaComponents(mediaImage: #imageLiteral(resourceName: "img_revista"), mediaText: "Revista", mediaAuxText: magazineTitle),
             mediaComponents(mediaImage: #imageLiteral(resourceName: "img_facebook"), mediaText: "Facebook", mediaAuxText: ""),
             mediaComponents(mediaImage: #imageLiteral(resourceName: "img_instagram"), mediaText: "Instagram", mediaAuxText: ""),
                mediaComponents(mediaImage: #imageLiteral(resourceName: "img_periodico"), mediaText: "Historico Periódico", mediaAuxText: ""),
                mediaComponents(mediaImage: #imageLiteral(resourceName: "img_revista"), mediaText: "Historico Revista", mediaAuxText: "")
        ]
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "media") as! MediaCell
        
        cell.imgMedia.image = tableViewData[indexPath.row].mediaImage
        cell.imgMedia.layer.cornerRadius = cell.imgMedia.frame.size.width / 2
        cell.imgMedia.clipsToBounds = true
        cell.imgMedia.contentMode = .scaleAspectFill
        cell.textMedia.text = tableViewData[indexPath.row].mediaText
        cell.dateMedia.text = tableViewData[indexPath.row].mediaAuxText
        cell.dateMedia.font = UIFont.systemFont(ofSize: 13.0)
        
        cell.layer.borderWidth = CGFloat(5.0)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let option = indexPath.row
        ////print("You tapped cell number \(indexPath.row).")
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: seguesIdentifiers[indexPath.row], sender: self)
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
