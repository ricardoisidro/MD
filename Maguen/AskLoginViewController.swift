//
//  AskLoginViewController.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/8/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import CryptoSwift
import SQLite

class AskLoginViewController: UIViewController, UITextFieldDelegate, XMLParserDelegate {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var dataTask: URLSessionDataTask?
    let mySession = URLSession.shared
    var parser = XMLParser()
    var currentParsingElement:String = ""
    var soapString:String = ""
    
    var database: Connection!
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
    
    
    var activityIndicatorView = UIView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        loginView.backgroundColor = MaguenColors.black1
        loginView.layer.cornerRadius = 10
        loginView.layer.masksToBounds = true
        btnOK.layer.cornerRadius = 10
        btnOK.layer.masksToBounds = true
        btnCancel.layer.cornerRadius = 10
        btnCancel.layer.masksToBounds = true
        
        txtUsuario.delegate = self
        txtPassword.delegate = self
        
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.underlinedWhenSelected()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.underlineWhenNonSelected()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtUsuario:
            txtPassword.becomeFirstResponder()
        case txtPassword:
            txtPassword.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func cancelLogin(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func makeLogin(_ sender: UIButton) {
        
        //let cipherRequest: Array<UInt8>
        //let aes: AES
        
        addLoadingView()
        guard let user = txtUsuario.text else {
            print("No user")
            return
        }
        guard let pass = txtPassword.text else {
            print("No password")
            return
        }
        //get data to send
        let loginRequest = LoginRequest(contrasena: pass, imei: "356021081404192", sistema_operativo: "iOS", usuario: user)
        
        let chainEncodedandEncrypted = encodeAndEncryptJSONString(LoginRequest: loginRequest)
        
        let soapMessage =
        "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetUsuarioApp xmlns='http://tempuri.org/'><Cadena>\(chainEncodedandEncrypted.toBase64()!)</Cadena><Token></Token></GetUsuarioApp></soap:Body></soap:Envelope>"
        
        //Prepare request
        let url = URL(string: MaguenCredentials.getUsuarioApp)
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
    
    //MARK:- XML Delegate methods
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsingElement = elementName
        if elementName == "GetUsuarioAppResponse" {
            //print("Started parsing...")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            if currentParsingElement == "GetUsuarioAppResult" {
                self.soapString += foundedChar
            }
            else {
                self.soapString += "nothing"
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "GetUsuarioAppResponse" {
            print("Ended parsing...")
            
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.updateUI()
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
    
    func encodeAndEncryptJSONString(LoginRequest: LoginRequest) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(LoginRequest)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err {
            print("encodeAndEncryptJSONString error: \(err)")
        }
        return cipherRequest
    }
    
    /*func decryptAndDecodeJSONString() -> LoginResponse {
        var loginResultData: LoginResponse = LoginResponse()
        do {
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapString.decryptBase64ToString(cipher: aes)
            loginResultData = try jsonDecoder.decode(LoginResponse.self, from: Data(decrypted.utf8))
     
        }
        catch let err {
     
        }
        return loginResultData
    }*/
    
    func updateUI() {
        do {
            
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapString.decryptBase64ToString(cipher: aes)
            
            let loginResult = try jsonDecoder.decode(LoginResponse.self, from: Data(decrypted.utf8))
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            
            let sexo = loginResult.Value.sexo == "H"
            let savedSex = sexo ? "HOMBRE" : "MUJER"
            let birthDate = loginResult.Value.fecha_nacimiento.prefix(10)
            
            onCreateUserDB(database: db)
            onInsertUserDB(objeto: loginResult, database: db)
            
            UserDefaults.standard.set(loginResult.Value.nombre, forKey: "name")
            UserDefaults.standard.set(loginResult.Value.primer_apellido, forKey: "surname1")
            UserDefaults.standard.set(loginResult.Value.segundo_apellido, forKey: "surname2")
            UserDefaults.standard.set(savedSex, forKey: "sex")
            UserDefaults.standard.set(birthDate, forKey: "birthday")
            UserDefaults.standard.set(loginResult.Value.correo, forKey: "mail")
            UserDefaults.standard.set(loginResult.Value.telefonoActual.numero, forKey: "phone")
            UserDefaults.standard.set(loginResult.Value.credencialActual.fotografia, forKey: "photo")
            UserDefaults.standard.set(loginResult.Value.usuario, forKey: "user")
            
            
            
            
            
        }
        catch let jsonErr{
            print("UpdateUI error: \(jsonErr)")
        }
    }
    
    //MARK: - WS ActivityIndicator
    func addLoadingView() {
        // You only need to adjust this frame to move it anywhere you want
        activityIndicatorView = UIView(frame: CGRect(x: view.frame.midX - 140, y: view.frame.midY - 25, width: 280, height: 50))
        activityIndicatorView.backgroundColor = UIColor.white
        activityIndicatorView.alpha = 0.8
        activityIndicatorView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = "Validando credenciales..."
        
        activityIndicatorView.addSubview(activityView)
        activityIndicatorView.addSubview(textLabel)
        
        view.addSubview(activityIndicatorView)
    }
    
    func onCreateUserDB(database: Connection) {
        
        do {
            //let db = database
            try database.run(db_user.create(ifNotExists: true) { t in
                t.column(db_user_id, primaryKey: true)
                t.column(db_user_name)
                t.column(db_user_surname1)
                t.column(db_user_surname2)
                t.column(db_user_sex)
                t.column(db_user_birthday)
                t.column(db_user_mail)
                t.column(db_user_phone)
                t.column(db_user_photo)//"fecha_modificacion" TEXT
                t.column(db_user_idtype)
                t.column(db_user_username)
                t.column(db_user_idactivedate)
                t.column(db_user_cardid)
            })
        }
        catch let ex {
            print("onCreateUser SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertUserDB(objeto: LoginResponse, database: Connection) {
        do {
            //let db = database
            let insert = db_user.insert(or: .replace,
                                             db_user_id <- Int64(objeto.Value.credencialActual.usuario_app_id),
                                             db_user_name <- objeto.Value.nombre,
                                             db_user_surname1 <- objeto.Value.primer_apellido,
                                             db_user_surname2 <- objeto.Value.segundo_apellido,
                                             db_user_sex <- objeto.Value.sexo,
                                             db_user_birthday <- objeto.Value.fecha_nacimiento,
                                             db_user_mail <- objeto.Value.correo,
                                             db_user_phone <- objeto.Value.telefonoActual.numero,
                                             db_user_photo <- objeto.Value.credencialActual.fotografia,
                                             db_user_idtype <- Int64(objeto.Value.categoria_id),
                                             db_user_username <- objeto.Value.usuario,
                                             db_user_idactivedate <- objeto.Value.credencialActual.fecha_vencimiento,
                                             db_user_cardid <- Int64(objeto.Value.credencialActual.credencial_id))
            
            try database.run(insert)
        }
        catch let ex {
            print("onInsertCategoriaCentro Error: \(ex)")
        }
        
    }

    
}
