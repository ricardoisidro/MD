//
//  AppDelegate.swift
//  Maguen
//
//  Created by Ricardo Isidro on 10/11/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import CryptoSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    
    /*var dataTask: URLSessionDataTask?
    let mySession = URLSession.shared
    var parser = XMLParser()
    var currentParsingElement:String = ""
    var soapString:String = ""
    var windowsToSync: [String] = [String]()*/
    
    let lastDate = UserDefaults.standard.string(forKey: "dateLastSync")

    //MARK: - TabBarController delegate
    // This delegate open the modal view before open the desired view.
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let validString = UserDefaults.standard.string(forKey: "name") ?? ""
        let sessionisEmpty = (validString == "")
        if viewController is CardController && sessionisEmpty {
            if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController") {
                tabBarController.present(popUpVC, animated: true)
                //tabBarController.selectedIndex = 1
                return false
            }
        }
        else if viewController is NewSettingsViewController && sessionisEmpty {
            if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController") {
                tabBarController.present(popUpVC, animated: true)
                //tabBarController.selectedIndex = 4
                return false
                
                //192.168.1.171
            }
        }
        
        return true
    }
    
    // This delegate open the modal view after open the desired view.
    /*func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let validString = UserDefaults.standard.string(forKey: "name") ?? ""
        let sessionisEmpty = (validString == "")
        if viewController is CardController && sessionisEmpty {
            if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController") {
                tabBarController.present(popUpVC, animated: true)
                print("Pedir login antes de la credencial")
            }
        }
        else if viewController is NewSettingsViewController && sessionisEmpty {
            if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController") {
                tabBarController.present(popUpVC, animated: true)
                print("Pedir login antes de los ajustes")
            }
        }
    }*/

    //MARK: - App delegates
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if (UserDefaults.standard.object(forKey: "dateLastSync") == nil) {
            UserDefaults.standard.set("01/01/1990 00:00:00", forKey: "dateLastSync")
        }
        else {
            
        }
        
        //let getModifyTablesRequest = GetModifyTablesRequest(FechaSincronizacion: lastDate!)
        //print(getModifyTablesRequest)
        let aesJSON = AESforJSON()
        let chainTablesEncodedandEncrypted = aesJSON.encodeAndEncryptJSONTablesString(fecha: lastDate!)
        //print(chainTablesEncodedandEncrypted.toBase64()!)

        let soapXMLTables = Global.shared.createSOAPXMLString(methodName: "GetModifyTables", encryptedString: chainTablesEncodedandEncrypted)
        
        let soapRequest = CallSOAP()
        soapRequest.makeRequest(endpoint: MaguenCredentials.getModifyTables, soapMessage: soapXMLTables)
        
        while !soapRequest.done {
            usleep(100000)
            
        }
        let tablesToSync = self.getTablesList(soapResult: soapRequest.soapResult)
        
        for tables in tablesToSync  {
            print(tables)
            let chainIDsEncodedandEncrypted = aesJSON.encodeAndEncryptJSONIDsString(fecha: lastDate!, tableName: tables)
            //print(chainIDsEncodedandEncrypted.toBase64()!)
            let soapXMLIDs = Global.shared.createSOAPXMLString(methodName: "GetIDs", encryptedString: chainIDsEncodedandEncrypted)
            soapRequest.makeRequest(endpoint: MaguenCredentials.getModifyID, soapMessage: soapXMLIDs)
            while !soapRequest.done {
                usleep(100000)
                
            }
            let idsToSync = self.getIDList(soapResult: soapRequest.soapResult)
            for ids in idsToSync{
                print(ids)
                let chainEntityEncodedAndEncrypted = aesJSON.encodeAndEncryptJSONEntityString(tableName: tables, id: ids)
                let soapXMLEntities = Global.shared.createSOAPXMLString(methodName: "GetEntidad", encryptedString: chainEntityEncodedAndEncrypted)
                //print(soapXMLEntities)
                soapRequest.makeRequest(endpoint: MaguenCredentials.getEntidad, soapMessage: soapXMLEntities)
                while !soapRequest.done {
                    usleep(100000)
                }
                //print(soapRequest.soapResult)
                let entitiesToSync = self.getEntitiesList(soapResult: soapRequest.soapResult, table: tables)
                //for entities in entitiesToSync{
                print(entitiesToSync)
                //}
            }
        }
        
        let currentDate = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm:ss"
        print(dateFormat.string(from: currentDate))
        //UserDefaults.standard.set("01/01/1990 00:00:00", forKey: "dateLastSync")
        
        /*//Prepare request
        let url = URL(string: MaguenCredentials.getModifyTables)
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
            let modifyTablesparser = XMLParser(data: data)
            modifyTablesparser.delegate = self
            modifyTablesparser.parse()
        }
        dataTask?.resume()*/
        
        return true
    }
    
    func getTablesList(soapResult: String) -> [String] {
        var tablesToSync: [String] = [String]()
        do {
            
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapResult.decryptBase64ToString(cipher: aes)
            
            let modifyTablesResult = try jsonDecoder.decode(GetModifyTablesResponse.self, from: Data(decrypted.utf8))
            
            
            tablesToSync = modifyTablesResult.Value.components(separatedBy: ",")
            
            
            
        }
        catch let jsonErr{
            print("getTablesList error: \(jsonErr)")
        }
        return tablesToSync
        
    }
    
    func getIDList(soapResult: String) -> [String]{
        var idToSync: [String] = []
        do {
            
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapResult.decryptBase64ToString(cipher: aes)
            
            let idTablesResult = try jsonDecoder.decode(GetModifyTablesResponse.self, from: Data(decrypted.utf8))
            
            
            idToSync = idTablesResult.Value.components(separatedBy: "@")
            /*for i in 0...(idToSync.count - 1) {
                print(idToSync[i])
            }*/
            
            
        }
        catch let jsonErr{
            print("getTablesList error: \(jsonErr)")
        }
        
        return idToSync
    }
    
    func getEntitiesList(soapResult: String, table: String) -> String{
        var entitiesToSync: String = ""
        do {
            
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapResult.decryptBase64ToString(cipher: aes)
            
            let entityTablesResult = try jsonDecoder.decode(GetModifyTablesResponse.self, from: Data(decrypted.utf8))
            
            
            //entitiesToSync = entityTablesResult.Value.components(separatedBy: "|@")
            entitiesToSync = entityTablesResult.Value
            /*for i in 0...(idToSync.count - 1) {
             print(idToSync[i])
             }*/
            if(table == "categoria_centro") {
                let ccm = CategoriaCentroModel.deserializaCategoriaCentro(dato: entitiesToSync)
            }
            else if(table == "domicilio") {
                //let dm = 
            }
            
            
        }
        catch let jsonErr{
            print("getTablesList error: \(jsonErr)")
        }
        
        return entitiesToSync
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("Hi, Im back")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    //MARK: - Decode/encode funcs 
    /*func encodeAndEncryptJSONTablesString(GetModifyTablesRequest: GetModifyTablesRequest) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(GetModifyTablesRequest)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err {
            print("encodeAndEncryptJSONTablesString error: \(err)")
        }
        return cipherRequest
    }
    
    /*func getTablesList() {
        do {
            
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapString.decryptBase64ToString(cipher: aes)
            
            let modifyTablesResult = try jsonDecoder.decode(GetModifyTablesResponse.self, from: Data(decrypted.utf8))
            
            
            windowsToSync = modifyTablesResult.Value.components(separatedBy: ",")
            for i in 0...(windowsToSync.count - 1) {
                print(windowsToSync[i])
            }
            
            processID()
        }
        catch let jsonErr{
            print("getTablesList error: \(jsonErr)")
        }
    }*/
    
    /*func processID() {
        let getModifiedIDRequest = GetIDRequest(FechaSincronizacion: lastDate!, Tables: windowsToSync[1])
        print(getModifiedIDRequest)
        let chainIDEncodedandEncrypted = encodeAndEncryptJSONIDString(GetRequest: getModifiedIDRequest)
        
        print(chainIDEncodedandEncrypted.toBase64()!)
        
        let soapMessage =
        "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetIDs xmlns='http://tempuri.org/'><Cadena>\(chainIDEncodedandEncrypted.toBase64()!)</Cadena><Token></Token></GetIDs></soap:Body></soap:Envelope>"
        
        //Prepare request
        let url = URL(string: MaguenCredentials.getModifyID)
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
            let idparser = MyClass()
            parser.delegate = idparser
            parser.parse()
        }
        dataTask?.resume()
        
        
    }*/

    /*func encodeAndEncryptJSONIDString(GetRequest: GetIDRequest) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(GetRequest)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
        
        }
        catch let err {
            print("encodeAndEncryptJSONIDString error: \(err)")
        }
        return cipherRequest
    }*/

    //MARK:- XMLParserDelegate methods
    
    /*func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsingElement = elementName
        if elementName == "GetModifyTablesResponse" {
            //print("Started parsing modifytables...")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            if currentParsingElement == "GetModifyTablesResult" {
                self.soapString = ""
                self.soapString += foundedChar
            }
            else {
                self.soapString += "nothing"
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "GetModifyTablesResponse" {
            //print("Ended parsing modifytables...")
            
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.getTablesList()
            //self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }*/*/
    
    
}

