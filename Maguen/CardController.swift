//
//  CardController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/12/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct usuario {
    var nombre: String
    var apellido1: String
    var fecha: String
    var tipoCredencial: Int
    var imagen: String
    var idCredencial: Int
}

class CardController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardBackground: UIImageView!
    @IBOutlet weak var cardPhoto: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtSurname: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtClass: UITextView!
    
    let db_user = Table("usuariomaguen")
    let db_user_id = Expression<Int64>("user_id")
    let db_user_name = Expression<String>("user_name")
    let db_user_surname1 = Expression<String>("user_surname1")
    let db_user_surname2 = Expression<String>("user_surname2")
    let db_user_sex = Expression<String>("user_sex")
    let db_user_birthday = Expression<String>("user_birthday")
    let db_user_mail = Expression<String>("user_mail")
    let db_user_phone = Expression<String>("user_phone")
    let db_user_photo = Expression<String>("user_photo")
    let db_user_username = Expression<String>("user_username")
    let db_user_idtype = Expression<Int64>("user_idtype")
    let db_user_idactivedate = Expression<String>("user_idactivedate")
    let db_user_cardid = Expression<Int64>("user_cardid")

    var tableData = [usuario]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.backgroundColor = .black
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        
        self.view.backgroundColor = MaguenColors.black1

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            let query = db_user.select(db_user_name, db_user_surname1, db_user_surname2, db_user_idactivedate, db_user_idtype, db_user_photo, db_user_cardid)
            guard let queryResults = try? db.prepare(query) else {
                print("ERROR al consultar usuario")
                return
            }
            
            for row in queryResults {
                print("nombre: \(row[db_user_name]), apellido: \(row[db_user_surname1]), fecha vig.: \(row[db_user_idactivedate]), tipoid: \(row[db_user_idtype]), cardid: \(row[db_user_cardid])")
                let apellido = try row.get(db_user_surname1) + " " + row.get(db_user_surname2)
                let data = usuario(nombre: try row.get(db_user_name), apellido1: apellido, fecha: try row.get(db_user_idactivedate), tipoCredencial: Int(try row.get(db_user_idtype)), imagen: try row.get(db_user_photo), idCredencial: try Int(row.get(db_user_cardid)))
                tableData.append(data)
            }
            
        }
        catch let ex {
            print("ReadHorarioClaseDB in ClassDetail error: \(ex)")
        }
        
        let imageDecoded: Data = Data(base64Encoded: tableData[0].imagen)!
        let avatarImage: UIImage = UIImage(data: imageDecoded) ?? #imageLiteral(resourceName: "img_foto_default")
        cardPhoto.image = avatarImage
        
        txtName.text = tableData[0].nombre
        txtName.font = UIFont.boldSystemFont(ofSize: 17.0)
        txtSurname.text = tableData[0].apellido1
        txtSurname.font = UIFont.boldSystemFont(ofSize: 15.0)
        txtDate.text = String(tableData[0].fecha.prefix(10))
        txtDate.font = UIFont.systemFont(ofSize: 15.0)
        
        if(tableData[0].tipoCredencial == 1) {
            cardBackground.image = #imageLiteral(resourceName: "credencial_socio")
            txtClass.text = "SOCIO"
            txtClass.font = UIFont.systemFont(ofSize: 25.0)

        }
        else {
            cardBackground.image = #imageLiteral(resourceName: "credencial_invitado")
            txtClass.text = "SOCIO INVITADO"
            txtClass.font = UIFont.boldSystemFont(ofSize: 21.0)
        }
    }
}
