//
//  HistRevistaTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/11/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct historicorComponents {
    var hpImageR = UIImage()
    var hpTextR = String()
    var nPag = Int64()
    var idPub = Int64()
}


class HistRevistaTableViewController: UITableViewController {

    var tableViewData = [historicorComponents]()
    
    var revistaTitle: String = ""
    
    
    
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
            let query1 = db_publicacion.select(db_descripcion,db_paginas,db_publicacion_id).order(db_fecha_inicial_publicacion.date.desc).where(db_categoria_publicacion_id == 2).where(db_eliminado == 0)
            let listRevistas = try db.prepare(query1)
            
            for item in listRevistas
            {
                let titulo = try item.get(db_descripcion) ?? ""
                let imagen = #imageLiteral(resourceName: "img_periodico")
                let nP = try item.get(db_paginas)
                let idP = try item.get(db_publicacion_id)
                
                tableViewData.append(historicorComponents(hpImageR: imagen, hpTextR: titulo,nPag: nP,idPub: idP))
            }
            
            //  dailyTitle = try currentDaily?.get(db_descripcion) ?? ""
            //print(dailyTitle!)
            
            
            
            
        }
        catch let err {
            print("Read publicacionDB error: \(err)")
            
        }
        
        
        
        
        
        
     /*

        tableViewData =
            [historicorComponents(hpImageR: #imageLiteral(resourceName: "img_revista") ,hpTextR: "Revista Octubre"),
             historicorComponents(hpImageR: #imageLiteral(resourceName: "img_revista"), hpTextR: "Revista Noviembre"),
             historicorComponents(hpImageR: #imageLiteral(resourceName: "img_revista"), hpTextR: "Revista Diciembre"),
             historicorComponents(hpImageR: #imageLiteral(resourceName: "img_revista"), hpTextR: "Revista Enero"),
             historicorComponents(hpImageR: #imageLiteral(resourceName: "img_revista"), hpTextR: "Revista Febrero")
        ]*/
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "hrevista") as! HistRevistaCell
        
        cell.imgHRevista.image = tableViewData[indexPath.row].hpImageR
        cell.imgHRevista.layer.cornerRadius = cell.imgHRevista.frame.size.width / 2
       
        cell.imgHRevista.clipsToBounds = true
        cell.imgHRevista.contentMode = .scaleAspectFill
        cell.textHRevista.text = tableViewData[indexPath.row].hpTextR
        
        
        cell.layer.borderWidth = CGFloat(5.0)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let option = indexPath.row
        //print("You tapped cell number \(indexPath.row).")
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "sRevista", sender: tableViewData[indexPath.row])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
          guard let segueData = sender as? historicorComponents
             else { return }
        
         let controller = segue.destination as? HistPeriodicoPageViewController
        controller?.noPaginas = segueData.nPag
        controller?.idPublicacion = segueData.idPub
        controller?.titlePublicacion = segueData.hpTextR
        
        
        
        
        
    }

}
