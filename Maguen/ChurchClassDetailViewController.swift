//
//  ChurchClassDetailViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 12/3/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct classComponents {
    var classDays = String()
    var classTime = String()
    var classTeacher = String()
}

class ChurchClassDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var tableViewClasses: UITableView!
    @IBOutlet weak var btnClose: UIButton!
    
    var txtMyTitle: String?
    var id: Int = -1
    var tableViewData = [classComponents]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db_horario_clase = Table("horario_clase")
        //let db_horario_clase_id = Expression<Int64>("horario_clase")
        let db_clase_id = Expression<Int64>("clase_id")
        let db_profesor = Expression<String>("profesor")
        let db_dias = Expression<String>("dias")
        let db_horario = Expression<String>("horario")
        let db_eliminado = Expression<Int64>("eliminado")

        modalView.layer.cornerRadius = 10
        modalView.layer.masksToBounds = true
        modalView.backgroundColor = MaguenColors.black2
        
        btnClose.layer.cornerRadius = 10
        btnClose.layer.masksToBounds = true
        
        if let textTitle = txtMyTitle {
            self.txtTitle.text = textTitle
        }
        let classid = id
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            let query = db_horario_clase.select(db_profesor, db_dias, db_horario)
                .where(db_clase_id == Int64(classid))
                .where(db_eliminado == 0)
            guard let queryResults = try? db.prepare(query) else {
                //print("ERROR al consultar centro")
                return
            }
            
            for row in queryResults {
                let data = classComponents(classDays: try row.get(db_dias), classTime: try row.get(db_horario), classTeacher: try row.get(db_profesor))
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewClasses.dequeueReusableCell(withIdentifier: "class") as! ClassesTableViewCell
        cell.txtClassDay.text = tableViewData[indexPath.row].classDays
        cell.txtClassTime.text = tableViewData[indexPath.row].classTime
        cell.txtClassTeacher.text = tableViewData[indexPath.row].classTeacher
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
