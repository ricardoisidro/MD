//
//  ChurchPrayDetailViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/13/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct prayComponents {
    var prayName = String()
    var prayTime = String()
    var prayType = Int()
}

class ChurchPrayDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var txtDay: UILabel!
    @IBOutlet weak var tableViewShajarit: UITableView!
    @IBOutlet weak var tableViewMinja: UITableView!
    @IBOutlet weak var tableViewArjit: UITableView!
    @IBOutlet weak var btnClose: UIButton!
    
    var txtTitle: String?
    var receivedId: Int = -1
    
    var tableViewData = [prayComponents]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db_horarios_reso = Table("horarios_reso")
        //let db_horarios_reso_id = Expression<Int64>("horarios_reso_id")
        let db_centro_id = Expression<Int64>("centro_id")
        let db_tipo_reso_id = Expression<Int64>("tipo_reso_id")
        let db_titulo = Expression<String>("titulo")
        let db_horario = Expression<String>("horario")
        let db_eliminado = Expression<Int64>("eliminado")
        //let db_fecha_modificacion = Expression<String>("fecha_modificacion")

        modalView.layer.cornerRadius = 10
        modalView.layer.masksToBounds = true
        modalView.backgroundColor = MaguenColors.black2
        
        btnClose.layer.cornerRadius = 10
        btnClose.layer.masksToBounds = true
        
        if let textTitle = txtTitle {
            self.txtDay.text = textTitle
        }
        
        let centroId = receivedId

        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            let query2 = db_horarios_reso.select(db_titulo, db_horario, db_tipo_reso_id).where(db_centro_id == Int64(centroId)).where(db_eliminado == 0)
            let queryResults = try? db.prepare(query2)
            
            for row in queryResults! {
                let data = prayComponents(prayName: try row.get(db_titulo), prayTime: try row.get(db_horario), prayType: try Int(row.get(db_tipo_reso_id)))
                tableViewData.append(data)
            }
            
        }
        catch let ex {
            print("ReadHorarioClaseDB in ClassDetail error: \(ex)")
        }
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewShajarit.dequeueReusableCell(withIdentifier: "pray") as! PrayTableViewCell
        cell.txtPrayTitle.text = tableViewData[indexPath.row].prayName
        cell.txtPrayTime.text = tableViewData[indexPath.row].prayTime
        cell.layer.borderWidth = CGFloat(1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
