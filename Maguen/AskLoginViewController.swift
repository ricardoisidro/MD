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
    
    //variables originales
    var database: Connection!
    
    
    let db_user = Table("usuarioapp")
    let db_usuario_app_id = Expression<Int64>("usuario_app_id")
    //let db_numero_maguen = Expression<String?>("numero_maguen")
    let db_nombre = Expression<String?>("nombre")
    let db_primer_apellido = Expression<String?>("primer_apellido")
    let db_segundo_apellido = Expression<String?>("segundo_apellido")
    let db_sexo = Expression<String?>("sexo")
    let db_fecha_nacimiento = Expression<Date?>("fecha_nacimiento")
    let db_usuario = Expression<String?>("usuario")
    let db_contrasena = Expression<String?>("contrasena")
    let db_correo = Expression<String?>("correo")
    let db_categoria_id = Expression<Int64>("categoria_id")
    let db_comunidad_id = Expression<Int64>("comunidad_id")
    let db_domicilio_id = Expression<Int64>("domicilio_id")
    let db_fecha_activacion = Expression<Date?>("fecha_activacion")
    let db_activo = Expression<Int64>("activo")
    let db_eliminado = Expression<Int64>("eliminado")
    
    //entidad credencial
   let table_credencial = Table("credencial")
    let db_credencial_id = Expression<Int64>("credencial_id")
    let db_fecha_expedicion = Expression<Date?>("fecha_expedicion")
    let db_fecha_vencimiento = Expression<Date?>("fecha_vencimiento")
    let db_vigencia = Expression<Int64>("vigencia")
    let db_activa = Expression<Int64>("activa")
    let db_fotografia = Expression<String?>("fotografia")
    let db_usuario_app_id_c = Expression<Int64>("usuario_app_id")
 
    //entidad telefono
    let table_telefonos = Table("telefonos")
    let db_telefono_id = Expression<Int64>("telefono_id")
    let db_usuario_app_id_t = Expression<Int64>("usuario_app_id")
    let db_numero = Expression<String?>("numero")
    let db_tipo_id = Expression<Int64>("tipo_id")
    let db_imei = Expression<String?>("imei")
    let db_sistema_operativo = Expression<String?>("sistema_operativo")
    let db_activo_t = Expression<Int64>("activo")
    
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
        guard let user = txtUsuario.text, user != "" else {
            showAlertWith(title: "Datos faltantes", message: "Agregar usuario")
            activityIndicatorView.removeFromSuperview()

            return
        }
        guard let pass = txtPassword.text, pass != "" else {
            showAlertWith(title: "Datos faltantes", message: "Agregar contraseña")
            activityIndicatorView.removeFromSuperview()

            return
        }
        //get data to send
        let lr = pGetUsuarioApp()
        lr.contrasena = pass
        lr.usuario = user
        lr.imei = "999999999999999"
        lr.sistema_operativo = "i0S"
        
        let chainEncodedandEncrypted = encodeAndEncryptJSONString(LoginRequest: lr)
        
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
            ////print("Started parsing...")
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
            ////print("Ended parsing...")
            
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.updateUI()
            
            
           /*
            
            let myView = self.storyboard!.instantiateViewController(withIdentifier: "HomeViewController")
            
           
            
            self.dismiss(animated: true, completion: nil)
             self.present(myView, animated: false)*/
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //let controller = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            
          /*  let myView = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
            
            myView.selectedIndex = 4
            */
            
            
            
           // self.present(myView.selectedIndex=4, animated: true)
            //self.present(controller, animated: false, completion: nil)
            //controller?.selectedIndex = 4

            
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        //print("parseErrorOccurred: \(parseError)")
    }
    
    func encodeAndEncryptJSONString(LoginRequest: pGetUsuarioApp) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(LoginRequest)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err{
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
            //print(decrypted)
            let loginResult = try jsonDecoder.decode(EBReturnUserApp.self, from: Data(decrypted.utf8))
            
            if loginResult.Correcto == true {
                Global.shared.loginOk = true
                UserDefaults.standard.set(true, forKey: "loginOk")
                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
                let db = try Connection(fileURL.path)
                
                let usrAppDowload = UsuarioApp()
                
                var birthdateNum: Date = Date()
                var activatedateNum: Date = Date()
                var expeddateNum: Date = Date()
                var vencdateNum: Date = Date()
                
                let dateformat = DateFormatter()
                dateformat.dateFormat = "dd/MM/yyyy HH:mm:ss"
                guard let birthdateString = loginResult.Value.fecha_nacimiento else {
                    return
                }
                birthdateNum = dateformat.date(from: birthdateString) ?? Date()
                guard let activatedateString = loginResult.Value.fecha_activacion else {
                    return
                }
                activatedateNum = dateformat.date(from: activatedateString) ?? Date()

                guard let expeditiondateString = loginResult.Value.credencialActual.fecha_expedicion else {
                    return
                }
                expeddateNum = dateformat.date(from: expeditiondateString) ?? Date()

                guard let vencimientodateString = loginResult.Value.credencialActual.fecha_vencimiento else {
                    return
                }
                vencdateNum = dateformat.date(from: vencimientodateString) ?? Date()

        
                usrAppDowload.usuario_app_id = loginResult.Value.usuario_app_id
                usrAppDowload.nombre = loginResult.Value.nombre
                usrAppDowload.primer_apellido = loginResult.Value.primer_apellido
                usrAppDowload.segundo_apellido = loginResult.Value.segundo_apellido
                usrAppDowload.sexo = loginResult.Value.sexo
                usrAppDowload.fecha_nacimiento = birthdateNum
                usrAppDowload.usuario = loginResult.Value.usuario
                usrAppDowload.contrasena = loginResult.Value.contrasena
                usrAppDowload.correo = loginResult.Value.correo
                usrAppDowload.categoria_id = loginResult.Value.categoria_id
                usrAppDowload.comunidad_id = loginResult.Value.comunidad_id
                usrAppDowload.domicilio_id = loginResult.Value.domicilio_id
                usrAppDowload.fecha_activacion = activatedateNum
                usrAppDowload.activo = loginResult.Value.activo
                usrAppDowload.eliminado = loginResult.Value.eliminado
                
                let creduser = Credencial()
                
                creduser.credencial_id = loginResult.Value.credencialActual.credencial_id
                creduser.fecha_expedicion = expeddateNum
                creduser.fecha_vencimiento = vencdateNum
                creduser.vigencia = loginResult.Value.credencialActual.vigencia
                creduser.activa = loginResult.Value.credencialActual.activa
                creduser.fotografia = loginResult.Value.credencialActual.fotografia
                creduser.usuario_app_id = loginResult.Value.credencialActual.usuario_app_id
                
                let telefuser = Telefonos()
                
                telefuser.telefono_id = loginResult.Value.telefonoActual.telefono_id
                telefuser.usuario_app_id = loginResult.Value.telefonoActual.usuario_app_id
                telefuser.numero = loginResult.Value.telefonoActual.numero
                telefuser.tipo_id = loginResult.Value.telefonoActual.tipo_id
                telefuser.imei = loginResult.Value.telefonoActual.imei
                telefuser.sistema_operativo = loginResult.Value.telefonoActual.sistema_operativo
                telefuser.activo = loginResult.Value.telefonoActual.activo
                
                if usrAppDowload.onCreate(connection: db) {
                    if usrAppDowload.onInsert(connection: db, objeto: usrAppDowload) {
                        if creduser.onCreate(connection: db) {
                            if creduser.onInsert(connection: db, objeto: creduser) {
                                if telefuser.onCreate(connection: db) {
                                    let _ = telefuser.onInsert(connection: db, objeto: telefuser)
                                }
                            }
                        }
                    }
                }
                
                UserDefaults.standard.set(loginResult.Value.comunidad_id, forKey: "comunidadID")
                
                let tabBarController = self.presentingViewController as? UITabBarController
                self.dismiss(animated: true) {
                    let _ = tabBarController?.selectedIndex = 4
                }
                
            }
            else {
                let msg = loginResult.MensajeError
                showAlertWith(title: "Aviso", message: msg)
                activityIndicatorView.removeFromSuperview()
            }
            
            
            
            
        }
        catch let jsonErr{
            print("UpdateUI error: \(jsonErr)")
            showAlertWith(title: "Error", message: "Error al validar credenciales")
            self.activityIndicatorView.removeFromSuperview()
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
    
    /*func onCreateUserDB(database: Connection) -> Bool {
        
        do {
           
            try database.run(db_user.create(ifNotExists: true) { t in
                t.column(db_usuario_app_id, primaryKey: true)
                t.column(db_nombre)
                t.column(db_primer_apellido)
                t.column(db_segundo_apellido)
                t.column(db_sexo)
                t.column(db_fecha_nacimiento)
                t.column(db_usuario)
                t.column(db_contrasena)
                t.column(db_correo)
                t.column(db_categoria_id)
                t.column(db_comunidad_id)
                t.column(db_domicilio_id)
                t.column(db_fecha_activacion)
                t.column(db_activo)
                t.column(db_eliminado)
            
          /*  try database.run(db_user.create(ifNotExists: true) { t in
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
                t.column(db_user_cardid)*/
            })
            ////print("se creo tabla con exito")
            return true
        }
        catch let ex{
            print("onCreateUser SQLite exception: \(ex)")
            return false
        }
        
    }
    
    func onInsertUserDB(objeto: LoginResponse, database: Connection) -> Bool {
        do {
            //let db = database
           /* let insert = db_user.insert(or: .replace,
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
            */
            
            //campos reales
          /*  let db_user = Table("usuarioapp")
            let db_usuario_app_id = Expression<Int64>("usuario_app_id")
            let db_numero_maguen = Expression<String?>("numero_maguen")
            let db_nombre = Expression<String?>("nombre")
            let db_primer_apellido = Expression<String?>("primer_apellido")
            let db_segundo_apellido = Expression<String?>("segundo_apellido")
            let db_sexo = Expression<String?>("sexo")
            let db_fecha_nacimiento = Expression<Date?>("fecha_nacimiento")
            let db_usuario = Expression<String?>("usuario")
            let db_contrasena = Expression<String?>("contrasena")
            let db_correo = Expression<String?>("correo")
            let db_categoria_id = Expression<Int64>("categoria_id")
            let db_comunidad_id = Expression<Int64>("comunidad_id")
            let db_domicilio_id = Expression<Int64>("domicilio_id")
            let db_fecha_activacion = Expression<Date?>("fecha_activacion")
            let db_activo = Expression<Int64>("activo")
            let db_eliminado = Expression<Int64>("eliminado")
            */
            let format = DateFormatter()
            format.dateFormat = "dd/MM/yyyy HH:mm:ss"
            let f = format.date(from: objeto.Value.fecha_nacimiento!)
            
            let factivacion = format.date(from: objeto.Value.fecha_activacion!)
            
            let comid = objeto.Value.comunidad_id ?? 0
            let act = objeto.Value.activo ?? 1
            let eliminado = objeto.Value.eliminado ?? 0
            
            let insert = db_user.insert(or: .replace,
                                        db_usuario_app_id <- objeto.Value.usuario_app_id,
            db_nombre <- objeto.Value.nombre,
            //db_numero_maguen <- objeto.Value.usuario,
            db_primer_apellido <- objeto.Value.primer_apellido,
            db_segundo_apellido <- objeto.Value.segundo_apellido,
            db_sexo <- objeto.Value.sexo,
            db_fecha_nacimiento <- f,
            db_fecha_activacion <- factivacion,
            db_correo <- objeto.Value.correo,
            db_contrasena <- objeto.Value.contrasena,
            db_comunidad_id <- Int64(comid),
            db_categoria_id <- Int64(objeto.Value.categoria_id),
            
            //db_user_phone <- objeto.Value.telefonoActual.numero,
            //db_user_photo <- objeto.Value.credencialActual.fotografia,
            db_activo <- Int64(act),
            db_usuario <- objeto.Value.usuario,
            db_domicilio_id <- 0,
            db_eliminado <-  Int64(eliminado))
            
           // db_user_idactivedate <- objeto.Value.credencialActual.fecha_vencimiento,
           // db_user_cardid <- Int64(objeto.Value.credencialActual.credencial_id))
            
            try database.run(insert)
            
             //print("se inserto con  exito")
            return true
        }
        catch let ex{
            print("onInsertCategoriaCentro Error: \(ex)")
            return false
        }
        
    }
    
    func onDeleteUserDB(objeto: LoginResponse, database: Connection) {
        do {
            //let db = database
            let format = DateFormatter()
            format.dateFormat = "dd/MM/yyyy"
            let f = format.date(from: objeto.Value.fecha_nacimiento!)
            let insert = db_user.insert(or: .replace,
                                        db_usuario_app_id <- Int64(objeto.Value.credencialActual.usuario_app_id),
                                        db_nombre <- objeto.Value.nombre,
                                        db_primer_apellido <- objeto.Value.primer_apellido,
                                        db_segundo_apellido <- objeto.Value.segundo_apellido,
                                        db_sexo <- objeto.Value.sexo,
                                        db_fecha_nacimiento <- f,
                                        db_correo <- objeto.Value.correo,
                                        //db_user_phone <- objeto.Value.telefonoActual.numero,
                //db_user_photo <- objeto.Value.credencialActual.fotografia,
                db_categoria_id <- Int64(objeto.Value.categoria_id),
                db_usuario <- objeto.Value.usuario)
            // db_user_idactivedate <- objeto.Value.credencialActual.fecha_vencimiento,
            // db_user_cardid <- Int64(objeto.Value.credencialActual.credencial_id))
            
        /*    let insert = db_user.insert(or: .replace,
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
            */
            try database.run(insert)
        }
        catch let ex{
            print("onInsertCategoriaCentro Error: \(ex)")
        }
        
    }

    
    func onCreateCredencialDB(database: Connection) -> Bool
    {
        do
        {
         
            try database.run(table_credencial.create(ifNotExists: true) { t in
                t.column(db_credencial_id, primaryKey: true)
                t.column(db_fecha_expedicion)
                t.column(db_fecha_vencimiento)
                t.column(db_vigencia)
                t.column(db_activa)
                t.column(db_fotografia)
                t.column(db_usuario_app_id)
            })
            
            //print("se creo tabla credenciales")
            return true
        }
        catch let ex{
            print("onCreateRegistro SQLite exception: \(ex)")
            return false
        }
    }
    func onInsertCredencialDB(objeto: LoginResponse, database: Connection) -> Bool {
        do
        {
            //let format = DateFormatter()
            //format.dateFormat = "dd/MM/yyyy HH:mm:ss"
            //let f = format.date(from: objeto.Value!.fecha_nacimiento)
            
            //let factivacion = format.date(from: objeto.Value!.fecha_activacion)
            
            
            let format = DateFormatter()
            format.dateFormat = "dd/MM/yyyy HH:mm:ss"
            let f = format.date(from: objeto.Value.credencialActual.fecha_expedicion!)
            let f2 = format.date(from: objeto.Value.credencialActual.fecha_vencimiento!)
            
            let insert = table_credencial.insert(or: .replace,
                                                 db_credencial_id <- Int64(objeto.Value.credencialActual.credencial_id),
                        db_fecha_expedicion <- f,
                        db_fecha_vencimiento <- f2,
                        db_vigencia <- Int64(objeto.Value.credencialActual.vigencia),
                        db_activa <- Int64(objeto.Value.credencialActual.activa),
                        db_fotografia <- objeto.Value.credencialActual.fotografia,
                        db_usuario_app_id <- Int64(objeto.Value.credencialActual.usuario_app_id))
                        
            try database.run(insert)
            //print("se inserto en tabla credenciales")
            return true
        }
        catch let ex{
            print("onInsertRegistro SQLite exception: \(ex)")
            return false
        }
    }
    
    func onCreateTelefonoDB(database: Connection) -> Bool
    {
        do
        {
        
            
            try database.run(table_telefonos.create(ifNotExists: true) { t in
                t.column(db_telefono_id, primaryKey: true)
                t.column(db_usuario_app_id)
                t.column(db_numero)
                t.column(db_tipo_id)
                t.column(db_imei)
                t.column(db_sistema_operativo)
                t.column(db_activo)
            })
            
            //print("se creo tabla telefonos")
            return true
        }
        catch let ex{
            print("onCreateRegistro SQLite exception: \(ex)")
            return false
        }
    }
    func onInsertTelefonoDB(objeto: LoginResponse, database: Connection) -> Bool {
        do
        {
          
            
            let insert = table_telefonos.insert(or: .replace,
                                                db_telefono_id <- Int64(objeto.Value.telefonoActual.telefono_id),
                                                db_usuario_app_id <- Int64(objeto.Value.telefonoActual.usuario_app_id),
                                                db_numero <- objeto.Value.telefonoActual.numero,
                                                db_tipo_id <- Int64(objeto.Value.telefonoActual.tipo_id),
                                                db_imei <- objeto.Value.telefonoActual.imei,
                                                db_sistema_operativo <- objeto.Value.telefonoActual.sistema_operativo,
                                                db_activo <- Int64(objeto.Value.telefonoActual.activo))
            
            try database.run(insert)
            //print("se inserto en tabla telefonos")
            return true
        }
        catch let ex{
            print("onInsertRegistro SQLite exception: \(ex)")
            return false
        }
    }*/
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
}
