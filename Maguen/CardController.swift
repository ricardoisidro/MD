//
//  CardController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/12/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite
import CryptoSwift

struct usuario {
    var id: Int
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
    @IBOutlet weak var cardQR: UIImageView!
    
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
    let db_user_idtype = Expression<Int64>("user_idtype") //categoria_id
    let db_user_idactivedate = Expression<String>("user_idactivedate")
    let db_user_cardid = Expression<Int64>("user_cardid")

    var tableDataSocio = [usuario]()
    
    //var qrcodeImage: CIImage!
    
    var codeElapsedTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            let query = db_user.select(db_user_id, db_user_name, db_user_surname1, db_user_surname2, db_user_idactivedate, db_user_idtype, db_user_photo, db_user_cardid, db_user_idtype)
            guard let queryResults = try? db.prepare(query) else {
                print("ERROR al consultar usuario")
                return
            }
            
            for row in queryResults {
                //print("app id: \(row[db_user_id]) nombre: \(row[db_user_name]), apellido: \(row[db_user_surname1]), fecha vig.: \(row[db_user_idactivedate]), tipoid: \(row[db_user_idtype]), cardid: \(row[db_user_cardid])")
                let bothSurnames = try row.get(db_user_surname1) + " " + row.get(db_user_surname2)
                let data = usuario(id: try Int(row.get(db_user_id)), nombre: try row.get(db_user_name), apellido1: bothSurnames, fecha: try row.get(db_user_idactivedate), tipoCredencial: Int(try row.get(db_user_idtype)), imagen: try row.get(db_user_photo), idCredencial: try Int(row.get(db_user_cardid)))
                tableDataSocio.append(data)
            }
            
        }
        catch let ex {
            print("ReadHorarioClaseDB in ClassDetail error: \(ex)")
        }
        
        cardView.backgroundColor = .black
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        
        self.view.backgroundColor = MaguenColors.black1

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //print QR
        let currentDate = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm:ss"
        //let currDate = dateFormat.string(from: currentDate)
        
        
        let lastCodeDate = UserDefaults.standard.string(forKey: "cardVigency")
        
        if lastCodeDate == nil {
            
            let futureDate = currentDate.addingTimeInterval(5.0*60.0)
            
            
            let futDate = dateFormat.string(from: futureDate)
            UserDefaults.standard.set(futDate, forKey: "cardVigency")
            
            //call QR service
            let aesJSON = AESforJSON()
            let chainTablesEncodedandEncrypted = aesJSON.encodeAndEncryptJSONQRString(id: tableDataSocio[0].id)
            let soapXMLTables = Global.shared.createSOAPXMLString(methodName: "GetDinamicWegan", encryptedString: chainTablesEncodedandEncrypted)
            let soapRequest = CallSOAP()
            soapRequest.makeRequest(endpoint: MaguenCredentials.getDinamicWegan, soapMessage: soapXMLTables)
            while !soapRequest.done {
                usleep(100000)
            }
            let wiganCode = getWiganCode(soapResult: soapRequest.soapResult)
            cardQR.image = generateQRCode(from: wiganCode)
        }
        else {
            let lastCodeDatetoDate = dateFormat.date(from: lastCodeDate!)
            if currentDate > lastCodeDatetoDate! {
                print("Genera code")
                //call QR service
                let aesJSON = AESforJSON()
                let chainTablesEncodedandEncrypted = aesJSON.encodeAndEncryptJSONQRString(id: tableDataSocio[0].id)
                let soapXMLTables = Global.shared.createSOAPXMLString(methodName: "GetDinamicWegan", encryptedString: chainTablesEncodedandEncrypted)
                let soapRequest = CallSOAP()
                soapRequest.makeRequest(endpoint: MaguenCredentials.getDinamicWegan, soapMessage: soapXMLTables)
                while !soapRequest.done {
                    usleep(100000)
                }
                let wiganCode = getWiganCode(soapResult: soapRequest.soapResult)
                cardQR.image = generateQRCode(from: wiganCode)
            }
            else {
                print("No necesito codigo")
            }
        }
        
        
        
        
        let imageDecoded: Data = Data(base64Encoded: tableDataSocio[0].imagen)!
        let avatarImage: UIImage = UIImage(data: imageDecoded) ?? #imageLiteral(resourceName: "img_foto_default")
        cardPhoto.image = avatarImage
        
        txtName.text = tableDataSocio[0].nombre
        txtName.font = UIFont.boldSystemFont(ofSize: 17.0)
        txtSurname.text = tableDataSocio[0].apellido1
        txtSurname.font = UIFont.boldSystemFont(ofSize: 15.0)
        txtDate.text = String(tableDataSocio[0].fecha.prefix(10))
        txtDate.font = UIFont.systemFont(ofSize: 15.0)
        
        if(tableDataSocio[0].tipoCredencial < 4) {
            cardBackground.image = #imageLiteral(resourceName: "credencial_socio")
            txtClass.text = "SOCIO"
            txtClass.font = UIFont.systemFont(ofSize: 25.0)

        }
        else if (tableDataSocio[0].tipoCredencial == 4){
            cardBackground.image = #imageLiteral(resourceName: "credencial_invitado")
            txtClass.text = "SOCIO INVITADO"
            txtClass.font = UIFont.boldSystemFont(ofSize: 21.0)
        }
        else {
            cardBackground.backgroundColor = UIColor.white
            txtClass.text = "SIN CREDENCIAL"
            txtClass.font = UIFont.boldSystemFont(ofSize: 21.0)
        }
    }
    
    func getWiganCode(soapResult: String) -> String {
        var code: String = ""
        do {
            
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapResult.decryptBase64ToString(cipher: aes)
            
            let codeResult = try jsonDecoder.decode(GetDinamicWeganResponse.self, from: Data(decrypted.utf8))
            
            code = codeResult.Value
            
            
        }
        catch let jsonErr{
            print("getWiganCode error: \(jsonErr)")
        }
        return code
        
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .utf8)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("M", forKey: "inputCorrectionLevel")
            
            guard let qrcodeImage = filter.outputImage else { return nil }
            
            let scaleX = cardQR.frame.size.width / qrcodeImage.extent.size.width
            let scaleY = cardQR.frame.size.height / qrcodeImage.extent.size.height
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
