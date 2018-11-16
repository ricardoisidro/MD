//
//  AskLoginViewController.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/8/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import CryptoSwift

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
            let myapp = UIStoryboard(name: "Main", bundle: nil)
            let controller = myapp.instantiateViewController(withIdentifier: "NewSettingsViewController")
            controller.tabBarController?.selectedIndex = 4
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
            
            let sexo = loginResult.Value.sexo == "H"
            let savedSex = sexo ? "HOMBRE" : "MUJER"
            let birthDate = loginResult.Value.fecha_nacimiento.prefix(10)
            
            UserDefaults.standard.set(loginResult.Value.nombre, forKey: "name")
            UserDefaults.standard.set(loginResult.Value.primer_apellido, forKey: "surname1")
            UserDefaults.standard.set(loginResult.Value.segundo_apellido, forKey: "surname2")
            UserDefaults.standard.set(savedSex, forKey: "sex")
            UserDefaults.standard.set(birthDate, forKey: "birthday")
            UserDefaults.standard.set(loginResult.Value.correo, forKey: "mail")
            UserDefaults.standard.set(loginResult.Value.telefonoActual.numero, forKey: "phone")
            UserDefaults.standard.set(loginResult.Value.credencialActual.fotografia, forKey: "photo")
            
            
            
        }
        catch let jsonErr{
            print(jsonErr)
        }
        
    }
    
}
