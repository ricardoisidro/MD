//
//  NewSettingsViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/6/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import CryptoSwift
import SQLite

class NewSettingsViewController: UIViewController, UINavigationControllerDelegate, XMLParserDelegate {
    
    enum ImageSource {
        case photoLibrary
        case camera
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imageTake: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    var dataTask: URLSessionDataTask?
    var mySession = URLSession.shared
    var currentParsingElement:String = ""
    var soapString:String = ""
    
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
    //var tableData: [String] = [usuario]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = MaguenColors.black1
        btnPhoto.layer.cornerRadius = 0.5 * btnPhoto.bounds.size.width
        btnPhoto.clipsToBounds = true
        btnSave.layer.cornerRadius = 10
        btnPhoto.layer.masksToBounds = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            let query = db_user.select(db_user_id, db_user_name, db_user_surname1, db_user_surname2, db_user_sex, db_user_birthday, db_user_idactivedate, db_user_idtype, db_user_photo, db_user_cardid, db_user_idtype)
            guard let queryResults = try? db.prepare(query) else {
                print("ERROR al consultar usuario")
                return
            }
            
            for row in queryResults {
                let bothSurnames = try row.get(db_user_surname1) + " " + row.get(db_user_surname2)
                _ = usuario(id: try Int(row.get(db_user_id)), nombre: try row.get(db_user_name), apellido1: bothSurnames, fecha: try row.get(db_user_idactivedate), tipoCredencial: Int(try row.get(db_user_idtype)), imagen: try row.get(db_user_photo), idCredencial: try Int(row.get(db_user_cardid)))
                //tableDataSocio.append(data)
            }
            
        }
        catch let ex {
            print("ReadHorarioClaseDB in ClassDetail error: \(ex)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //scroll on top always
        scrollView.setContentOffset(.zero, animated: true)
        let validString = UserDefaults.standard.string(forKey: "name") ?? ""
        let sessionisEmpty = (validString == "")
        if sessionisEmpty {
            btnSave.setTitle("GUARDAR CAMBIOS", for: .normal)
            btnSave.backgroundColor = MaguenColors.blue5
        }
        else {
            btnSave.setTitle("DESACTIVAR USUARIO", for: .normal)
            btnSave.backgroundColor = .orange
            
            let imageDecoded: Data = Data(base64Encoded: UserDefaults.standard.string(forKey: "photo") ?? "")!
            let avatarImage: UIImage = UIImage(data: imageDecoded) ?? #imageLiteral(resourceName: "img_foto_default")
            imageTake.image = avatarImage
        }
        
        
        
        let validUser = UserDefaults.standard.string(forKey: "user")
        let saldoRequest = SaldoRequest(usuario: validUser!)
        
        let chainEncodedandEncrypted = encodeAndEncryptJSONString(SaldoRequest: saldoRequest)
        
        let soapMessage =
        "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetSaldoActual xmlns='http://tempuri.org/'><Cadena>\(chainEncodedandEncrypted.toBase64()!)</Cadena><Token></Token></GetSaldoActual></soap:Body></soap:Envelope>"
        
        //Prepare request
        let url = URL(string: MaguenCredentials.getSaldoActual)
        let req = NSMutableURLRequest(url: url!)
        let msgLength = soapMessage.count
        req.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        req.httpMethod = "POST"
        req.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        //Make the request
        dataTask?.cancel()
        dataTask = mySession.dataTask(with: req as URLRequest) { (data, response, error) in
            defer { self.dataTask = nil }
            guard let data = data else { return }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        dataTask?.resume()
        
    }
    
    @IBAction func btnSaveorDiscard(_ sender: UIButton) {
        
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "surname1")
        UserDefaults.standard.removeObject(forKey: "surname2")
        UserDefaults.standard.removeObject(forKey: "sex")
        UserDefaults.standard.removeObject(forKey: "birthday")
        UserDefaults.standard.removeObject(forKey: "mail")
        UserDefaults.standard.removeObject(forKey: "phone")
        UserDefaults.standard.removeObject(forKey: "photo")
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.removeObject(forKey: "balance")
        //UserDefaults.standard.removeObject(forKey: "dateLastSync")
        
        self.tabBarController?.selectedIndex = 0
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - Camera methods
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func takePhoto(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    //MARK: - Saving Image here
    @IBAction func save(_ sender: AnyObject) {
        guard let selectedImage = imageTake.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func encodeAndEncryptJSONString(SaldoRequest: SaldoRequest) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(SaldoRequest)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err {
            print("encodeAndEncryptJSONString error: \(err)")
        }
        return cipherRequest
    }
    
    func updateAccount() {
        do {
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            var decrypted = try soapString.decryptBase64ToString(cipher: aes)
            //print("Cadena decrypted saldo: \(decrypted)")
            
            let saldoResult = try jsonDecoder.decode(SaldoResponse.self, from: Data(decrypted.utf8))
            //print("Saldo: \(saldoResult.Value)")
            UserDefaults.standard.set(saldoResult.Value, forKey: "balance")
        }
        catch let ex {
            print("updateSaldo error: \(ex)")
        }
    }
    
    //MARK:- XML Delegate methods
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsingElement = elementName
        if elementName == "GetSaldoActualResponse" {
            //print("Started parsing...")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            if currentParsingElement == "GetSaldoActualResult" {
                self.soapString = ""
                self.soapString += foundedChar
            }
            else {
                self.soapString += "nothing"
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "GetSaldoActualResponse" {
            //print("Ended parsing...")
            
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.updateAccount()
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }

}

extension NewSettingsViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        imageTake.image = selectedImage
    }
}
