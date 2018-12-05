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
    var rowDay: String?
    var rowValue = "1"
    
    var tableViewData1 = [prayComponents]()
    var tableViewData2 = [prayComponents]()
    var tableViewData3 = [prayComponents]()
    var tableViewData4 = [prayComponents]()
    var tableViewData5 = [prayComponents]()
    var tableViewData6 = [prayComponents]()
    var tableViewData7 = [prayComponents]()
    var tableViewData8 = [prayComponents]()
    var tableViewData9 = [prayComponents]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db_horarios_reso = Table("horarios_reso")
        let db_horarios_reso_id = Expression<Int64>("horarios_reso_id")
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
        rowValue = rowDay!
        
        let centroId = receivedId

        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            let query2 = db_horarios_reso.select(db_horarios_reso_id ,db_titulo, db_horario, db_tipo_reso_id, db_centro_id).where(db_eliminado == 0).where(db_centro_id == Int64(centroId))
            let queryResults = try? db.prepare(query2)
            
            for row in queryResults! {
                //print("titulo: \(row[db_titulo]), id: \(row[db_horarios_reso_id]), horario: \(row[db_horario]), tiporesoid: \(row[db_tipo_reso_id]), centro_id: \(row[db_centro_id])")
                let data = prayComponents(prayName: try row.get(db_titulo), prayTime: try row.get(db_horario), prayType: try Int(row.get(db_tipo_reso_id)))
                switch data.prayType {
                case 1:
                    tableViewData1.append(data)
                    break
                case 2:
                    tableViewData2.append(data)
                    break
                case 3:
                    tableViewData3.append(data)
                    break
                case 4:
                    tableViewData4.append(data)
                    break
                case 5:
                    tableViewData5.append(data)
                    break
                case 6:
                    tableViewData6.append(data)
                    break
                case 7:
                    tableViewData7.append(data)
                    break
                case 8:
                    tableViewData8.append(data)
                    break
                case 9:
                    tableViewData9.append(data)
                    break
                    
                default:
                    tableViewData1.append(data)
                    break
                }
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
        switch rowValue {
        case "1":
            if tableView == tableViewShajarit {
                return tableViewData1.count
            }
            else if tableView == tableViewMinja {
                return tableViewData2.count
            }
            else if tableView == tableViewArjit {
                return tableViewData3.count
            }
            else {
                return 1
            }
        case "2":
            if tableView == tableViewShajarit {
                return tableViewData4.count
            }
            else if tableView == tableViewMinja {
                return tableViewData5.count
            }
            else if tableView == tableViewArjit {
                return tableViewData6.count
            }
            else {
                return 1
            }
        case "3":
            if tableView == tableViewShajarit {
                return tableViewData7.count
            }
            else if tableView == tableViewMinja {
                return tableViewData8.count
            }
            else if tableView == tableViewArjit {
                return tableViewData9.count
            }
            else {
                return 1
            }
        default:
            return tableViewData1.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rowValue {
        case "1":
            if tableView == tableViewShajarit {
                let cell = tableViewShajarit.dequeueReusableCell(withIdentifier: "pray") as! PrayTableViewCell
                cell.txtPrayTitle.text = tableViewData1[indexPath.row].prayName
                cell.txtPrayTime.text = tableViewData1[indexPath.row].prayTime
                
                return cell
            }
            else if tableView == tableViewMinja {
                let cell = tableViewMinja.dequeueReusableCell(withIdentifier: "pray2") as! PrayTableViewCell
                cell.txtPrayTitle.text = tableViewData2[indexPath.row].prayName
                cell.txtPrayTime.text = tableViewData2[indexPath.row].prayTime
                
                return cell
            }
            else if tableView == tableViewArjit {
                let cell = tableViewArjit.dequeueReusableCell(withIdentifier: "pray3") as! PrayTableViewCell
                cell.txtPrayTitle.text = tableViewData3[indexPath.row].prayName
                cell.txtPrayTime.text = tableViewData3[indexPath.row].prayTime
                
                return cell
            }
            else {
                return UITableViewCell()
            }
        case "2":
            if tableView == tableViewShajarit {
                let cell = tableViewShajarit.dequeueReusableCell(withIdentifier: "pray") as! PrayTableViewCell
                cell.txtPrayTitle.text = tableViewData4[indexPath.row].prayName
                cell.txtPrayTime.text = tableViewData4[indexPath.row].prayTime
                
                return cell
            }
            else if tableView == tableViewMinja {
                let cell = tableViewMinja.dequeueReusableCell(withIdentifier: "pray2") as! PrayTableViewCell
                cell.txtPrayTitle.text = tableViewData5[indexPath.row].prayName
                cell.txtPrayTime.text = tableViewData5[indexPath.row].prayTime
                
                return cell
            }
            else if tableView == tableViewArjit {
                let cell = tableViewArjit.dequeueReusableCell(withIdentifier: "pray3") as! PrayTableViewCell
                cell.txtPrayTitle.text = tableViewData6[indexPath.row].prayName
                cell.txtPrayTime.text = tableViewData6[indexPath.row].prayTime
                
                return cell
            }
            else {
                return UITableViewCell()
            }
        case "3":
            if tableView == tableViewShajarit {
                let cell = tableViewShajarit.dequeueReusableCell(withIdentifier: "pray") as! PrayTableViewCell
                cell.txtPrayTitle.text = tableViewData7[indexPath.row].prayName
                cell.txtPrayTime.text = tableViewData7[indexPath.row].prayTime
                
                return cell
            }
            else if tableView == tableViewMinja {
                let cell = tableViewMinja.dequeueReusableCell(withIdentifier: "pray2") as! PrayTableViewCell
                cell.txtPrayTitle.text = tableViewData8[indexPath.row].prayName
                cell.txtPrayTime.text = tableViewData8[indexPath.row].prayTime
                
                return cell
            }
            else if tableView == tableViewArjit {
                let cell = tableViewArjit.dequeueReusableCell(withIdentifier: "pray3") as! PrayTableViewCell
                cell.txtPrayTitle.text = tableViewData9[indexPath.row].prayName
                cell.txtPrayTime.text = tableViewData9[indexPath.row].prayTime
                
                return cell
            }
            else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
