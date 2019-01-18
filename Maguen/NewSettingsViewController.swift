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

class NewSettingsViewController: UIViewController, UINavigationControllerDelegate {
    
    enum ImageSource {
        case photoLibrary
        case camera
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imageTake: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var formView: UIView!
    
    var imagePicker: UIImagePickerController!
    
    var dataTask: URLSessionDataTask?
    var mySession = URLSession.shared
    var currentParsingElement:String = ""
    var soapString:String = ""
    
    var nombre: String = ""
    var apellido1: String = ""
    var apellido2: String = ""
    var sexo: String = ""
    var fecha_nacimiento: Date? = nil
    var fecha_activacion: Date? = nil
    var usuario: String = ""
    var contrasena: String = ""
    var correo: String = ""
    var comunidad_id: Int = -1
    var categoria_id: Int = -1
    var credencial_id: Int = -1
    var activo: Int = -1
    var eliminado: Int = -1
    
    var isModoEdit = false
    
  /*  let db_user = Table("usuariomaguen")
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
    let db_user_cardid = Expression<Int64>("user_cardid")*/
    //var tableData: [String] = [usuario]()
    
    let db_user = Table("usuarioapp")
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
    
    private var embededVC: SettingsTableViewController!


    // 1: Desactivar 2: Guardar cambios
    var buttonAction: Int = 0
    
    let conn = SQLiteHelper.shared.inicializa(nameBD: "maguen")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.view.backgroundColor = MaguenColors.black1
        btnPhoto.layer.cornerRadius = 0.5 * btnPhoto.bounds.size.width
        btnPhoto.clipsToBounds = true
        btnSave.layer.cornerRadius = 10
        btnPhoto.layer.masksToBounds = true
        btnEdit.isHidden = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    
        
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //scroll on top always
        if isModoEdit {
            btnEdit.isHidden = true
            btnPhoto.isHidden = false
            

        }
        else {
            btnEdit.isHidden = false
            btnPhoto.isHidden = true


        }
        let c = Credencial()
        let cres = c.onReadData(connection: conn)
        let foto = cres.fotografia
        
        let imageDecoded: Data = Data(base64Encoded: foto!)!
        let avatarImage: UIImage = UIImage(data: imageDecoded) ?? #imageLiteral(resourceName: "img_foto_default")
        imageTake.image = avatarImage
        

        scrollView.setContentOffset(.zero, animated: true)
        let validString = UserDefaults.standard.string(forKey: "name") ?? ""
        let sessionisEmpty = (validString == "")
        if sessionisEmpty {
            btnSave.setTitle("GUARDAR CAMBIOS", for: .normal)
            btnSave.backgroundColor = MaguenColors.blue5
            buttonAction = 2
        }
        else {
            if btnEdit.isHidden == true {
                btnSave.setTitle("GUARDAR CAMBIOS", for: .normal)
                btnSave.backgroundColor = MaguenColors.blue5
                //btnPhoto.isHidden = false
                formView.isUserInteractionEnabled = true
                buttonAction = 2

            }
            else {
                btnSave.setTitle("DESACTIVAR USUARIO", for: .normal)
                btnSave.backgroundColor = .orange
                btnPhoto.isHidden = true
                formView.isUserInteractionEnabled = false
                buttonAction = 1
            }
        }
        
        let aesJSON = AESforJSON()
        
        let validUser = UserDefaults.standard.string(forKey: "user")
        let saldoRequest = SaldoRequest(usuario: validUser!)
        
        let stringEncodedandEncrypted = aesJSON.encodeAndEncryptJSONSaldo(SaldoRequest: saldoRequest)
        
        let soapXML = Global.shared.createSOAPXMLString(methodName: "GetSaldoActual", encryptedString: stringEncodedandEncrypted)
        
        let soapRequest = CallSOAP()
        
        soapRequest.makeRequest(endpoint: MaguenCredentials.getSaldoActual, soapMessage: soapXML)
        while !soapRequest.done {
            usleep(100000)
        }
        
        let res = aesJSON.decodeAndDecryptJSONSaldo(soapResult: soapRequest.soapResult)
        
        UserDefaults.standard.set(res, forKey: "balance")
        
        //btnPhoto.isHidden = true
        
        /*//Prepare request
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
        dataTask?.resume()*/
        
    }
    
    @IBAction func btnSaveorDiscard(_ sender: UIButton) {
        
        let c = Credencial()
        let t = Telefonos()
        let u = UsuarioApp()
        
        switch buttonAction {
        case 1: //Desactivar
            
            
            c.onDelete(connection: conn)
            t.onDelete(connection: conn)
            u.onDelete(connection: conn)
            
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
            self.tabBarController?.selectedIndex = 0
            break
            
        case 2: //Guardar
            
            let res = editarUsuario()
            
            if res.Correcto {
                
                let format = DateFormatter()
                format.dateFormat = "dd/MM/yyyy"
                
                
                let newName = self.embededVC.textConfigName.text
                let newSurname = self.embededVC.textConfigSurname1.text
                let newSurname2 = self.embededVC.textConfigSurname2.text
                let newBirthday = self.embededVC.textConfigBirthday.text
                
                let completeBirthday = newBirthday! + " 00:00:00"
                
                let newMail = self.embededVC.textConfigMail.text
                
                let selectedSex = self.embededVC.textConfigSex.text
                var newSex = ""
                switch selectedSex {
                case "HOMBRE":
                    newSex = "H"
                    break
                case "MUJER":
                    newSex = "M"
                    break
                default:
                    newSex = "H"
                    break
                }
                let cId = Int64(UserDefaults.standard.integer(forKey: "comunidadID"))
                
                let image = imageTake.image
                let imgTo64 = image!.pngData()
                let newImage = imgTo64?.base64EncodedString()
                
                let newPhone = self.embededVC.textConfigPhone.text
                
                if u.onUpdate(connection: conn, name: newName!, ap1: newSurname!, ap2: newSurname2!, date: completeBirthday, mail: newMail!, sex: newSex, community: cId) {
                    if t.onUpdate(connection: conn, phone: newPhone!) {
                        if c.onUpdate(connection: conn, picture: newImage!) {
                            isModoEdit = false
                            self.tabBarController?.selectedIndex = 1
                        }
                        else {
                             showAlertWith(title: "Aviso", message: "Error al actualizar foto")
                        }
                        
                    }
                    else {
                        showAlertWith(title: "Aviso", message: "Error al actualizar telefono")

                    }
                }
                else {
                    showAlertWith(title: "Aviso", message: "Error al actualizar usuario")
                }
                

            }
            else {
                let msg = res.MensajeError
                showAlertWith(title: "Alerta", message: msg)
            }



            break
        default:
            print("Default")
            break
        }
        
       
        //UserDefaults.standard.removeObject(forKey: "dateLastSync")
        
        
        
        
        
    }
    
    func editarUsuario() -> EBReturn {
    
        embededVC.GuardaEdicionSocio()
        
        let pSUA = pSetUsuarioApp()
        
        let c = Credencial()
        
        let t = Telefonos()
        
        let u = UsuarioApp()
        
        let jsUsuario = jsUsuarioApp()
        
        //jsUsuario.credencial_id
        
        guard let newName = self.embededVC.textConfigName.text, newName != "" else {
            showAlertWith(title: "Datos faltantes", message: "Agregar nombre válido")
            return EBReturn()
        }
        jsUsuario.nombre = newName
        
        guard let newSurname = self.embededVC.textConfigSurname1.text, newSurname != "" else {
            showAlertWith(title: "Datos faltantes", message: "Agregar apellido paterno")
            return EBReturn()
        }
        jsUsuario.primer_apellido = newSurname
        
        jsUsuario.segundo_apellido = self.embededVC.textConfigSurname2.text!
        
        let sex = self.embededVC.selectedSex
        if sex == "HOMBRE" {
            jsUsuario.sexo = "H"
        }
        else if sex == "MUJER" {
            jsUsuario.sexo = "M"
        }
        
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        /*let fechaFormulario = self.embededVC.textConfigBirthday.text
        let f = format.date(from: fechaFormulario!)*/
        
        guard let newBirthday = self.embededVC.textConfigBirthday.text, newBirthday != "" else {
            showAlertWith(title: "Datos faltantes", message: "Agregar fecha de nacimiento")
            return EBReturn()
        }

        let fechaNac = newBirthday
        jsUsuario.fecha_nacimiento = fechaNac + " 00:00:00"
        
        let resUsuarioApp = u.onReadData(connection: conn)
        
        /*let activeDate = resUsuarioApp.fecha_activacion
        let fechaAct = format.string(from: activeDate!)
        let f2 = format.date(from: fechaAct)
        
        jsUsuario.fecha_activacion = f2*/
        
        let activeDate = resUsuarioApp.fecha_activacion
        let activeDateString = format.string(from: activeDate!)
        let f2 = activeDateString + " 00:00:00"
        
        jsUsuario.fecha_activacion = f2
        
        jsUsuario.usuario = resUsuarioApp.usuario!
        
        // FIXME : repetido
        jsUsuario.numero_maguen = resUsuarioApp.usuario!

        jsUsuario.contrasena = resUsuarioApp.contrasena!
        
        guard let newMail = self.embededVC.textConfigMail.text, newMail != "" else {
            showAlertWith(title: "Datos faltantes", message: "Agregar correo")
            return EBReturn()
        }
        
        jsUsuario.correo = newMail
        jsUsuario.comunidad_id = Int64(UserDefaults.standard.integer(forKey: "comunidadID"))
        jsUsuario.categoria_id = resUsuarioApp.categoria_id
        
        jsUsuario.activo = resUsuarioApp.activo
        jsUsuario.eliminado = resUsuarioApp.eliminado
        
        jsUsuario.usuario_app_id = resUsuarioApp.usuario_app_id
        
        //jsUsuario.telefonoActual = ""
        //jsUsuario.credencialActual = ""
        
        
        let ptel = pTelefono()
        
        let resTelefono = t.onReadData(connection: conn)
        
        ptel.activo = resTelefono.activo
        ptel.usuario_app_id = resTelefono.usuario_app_id
        
        guard let newPhone = self.embededVC.textConfigPhone.text, newPhone != "" else {
            showAlertWith(title: "Datos faltantes", message: "Agregar teléfono")
            return EBReturn()
        }
        ptel.numero = newPhone
        ptel.tipo_id = resTelefono.tipo_id
        ptel.imei = resTelefono.imei
        ptel.sistema_operativo = resTelefono.sistema_operativo
        ptel.activo = resTelefono.activo
        ptel.telefono_id = resTelefono.telefono_id
        
        let image = imageTake.image
        let imgTo64 = image!.pngData()
        let imgString = imgTo64?.base64EncodedString()
        
        
        
        /*let image = btnPicture.image(for: .normal)
        let imgTo64 = image!.pngData()
        let imgString = imgTo64?.base64EncodedString(options: .lineLength64Characters)*/
        
        let pcred = pCredencial()
        
        let resCredencial = c.onReadData(connection: conn)
        
        pcred.credencial_id = resCredencial.credencial_id
        
        pcred.activa = resCredencial.activa
        pcred.vigencia = resCredencial.vigencia
        
        pcred.fotografia = imgString
        pcred.usuario_app_id = resCredencial.usuario_app_id
        
        let expDate = resCredencial.fecha_expedicion
        let expDateString = format.string(from: expDate!)
        let f3 = expDateString + " 00:00:00"

        pcred.fecha_expedicion = f3
        
        let endDate = resCredencial.fecha_vencimiento
        let endDateString = format.string(from: endDate!)
        let f4 = endDateString + " 00:00:00"
        
        pcred.fecha_vencimiento = f4

        
        pSUA.usuarioActual = jsUsuario
        pSUA.telefonoActual = ptel
        pSUA.credencialActual = pcred


        let aes = AESforJSON()
        let strEncode = aes.encodeAndEncryptJSONSetUsuarioApp(objeto: pSUA)
        //print(strEncode)
        
        let soapXMLTables = Global.shared.createSOAPXMLString(methodName: "SetUsuarioApp", encryptedString: strEncode)
        
        let soapRequest = CallSOAP()
        
        soapRequest.makeRequest(endpoint: MaguenCredentials.setUsuarioApp, soapMessage: soapXMLTables)
        
        while !soapRequest.done {
            usleep(100000)
        }
        
        let res = aes.decodeAndDecryptJSONSetUsuarioApp(soapResult: soapRequest.soapResult)
        
        return res
        
       /* nombre =  ?? ""
        apellido1 = self.embededVC.textConfigSurname1.text  ?? ""
        apellido2 = self.embededVC.textConfigSurname2.text  ?? ""
        print("\(String(describing: nombre)) \(String(describing: apellido1)) \(String(describing: apellido2))")*/
    }
    
    @IBAction func btnEdit(_ sender: UIButton) {
        if isModoEdit == false {
            btnPhoto.isHidden = false
            btnSave.setTitle("GUARDAR CAMBIOS", for: .normal)
            btnSave.backgroundColor = MaguenColors.blue5
            btnEdit.isHidden = true
            formView.isUserInteractionEnabled = true
            //formView.
            buttonAction = 2
            isModoEdit = true
        }
        
        

        
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
        let ac = UIAlertController(title: "Imagen", message: "Selecciona el origen de la foto:", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Cámara", style: .default) {
            (UIAlertAction) in
            self.selectImageFrom(.camera)
        }
        let action2 = UIAlertAction(title: "Galería", style: .default) {
            (UIAlertAction) in
            self.selectImageFrom(.photoLibrary)
        }
        
        ac.addAction(action1)
        ac.addAction(action2)
        ac.view.layoutIfNeeded()
        
        present(ac, animated: true)
        
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
    

    
/*    func updateAccount() {
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
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SettingsTableViewController, segue.identifier == "embededSegue" {
            self.embededVC = vc
            
        }
    }

}

extension NewSettingsViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imagePicker.dismiss(animated: false, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.imageResize(with: selectedImage)
                
            })
        }
        
    }
    
    func imageResize(with image: UIImage){
        
        let screenWidth = UIScreen.main.bounds.width
        
        let scaleWidth = screenWidth * 0.5
        let scaleHeight = screenWidth * 0.75
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: scaleWidth, height: scaleHeight), false, 1.0)
        
        image.draw(in: CGRect(x: 0, y: 0, width: scaleWidth, height: scaleHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageTake.image = newImage
        //isModoEdit = true
        
        
        //btnPicture.setImage(newImage, for: .normal)
        
    }
}
