//
//  CallSOAP.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/21/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import CryptoSwift

class CallSOAP : NSObject, XMLParserDelegate {
    
    var dataTask: URLSessionDataTask?
    let mySession = URLSession.shared
    var parser = XMLParser()
    var currentParsingElement:String = ""
    var soapResult:String = ""
    var tablesToSync: [String] = [String]()
    var idToSync: [String] = [String]()
    var done: Bool = false

    var parseType: String = ""
    var parseResult: String = ""
    
    let lastDate = UserDefaults.standard.string(forKey: "dateLastSync")
    
    func makeRequest(endpoint: String, soapMessage: String) {
        //Prepare request
        if endpoint.contains("GetModifyTables") {
            parseType = "GetModifyTablesResponse"
            parseResult = "GetModifyTablesResult"
        }
        else if endpoint.contains("GetIDs"){
            parseType = "GetIDsResponse"
            parseResult = "GetIDsResult"
        }
        
        let url = URL(string: endpoint)
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
    
    //MARK:- XMLParserDelegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsingElement = elementName
        if elementName == parseType {
            print("Started parsing modifytables...")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            if currentParsingElement == parseResult {
                self.soapResult = ""
                self.soapResult += foundedChar
            }
            else {
                self.soapResult += "nothing"
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == parseType {
            //print("Ended parsing modifytables...")
            
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            if(self.parseType == "GetModifyTablesResponse") {
                self.getTablesList()
            }
            else {
                self.getIDList()
            }
            //
            
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
    
    func getTablesList(){
        do {
            
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapResult.decryptBase64ToString(cipher: aes)
            
            let modifyTablesResult = try jsonDecoder.decode(GetModifyTablesResponse.self, from: Data(decrypted.utf8))
            
            
            tablesToSync = modifyTablesResult.Value.components(separatedBy: ",")
            
            let aesJSON = AESforJSON()
            
            for i in 0...1  {
                //print(tableName)
                let chainIDsEncodedandEncrypted = aesJSON.encodeAndEncryptJSONIDsString(fecha: lastDate!, tableName: tablesToSync[i])
                //print(chainIDsEncodedandEncrypted.toBase64()!)
                let soapXML = Global.shared.createSOAPXMLString(methodName: "GetIDs", encryptedString: chainIDsEncodedandEncrypted)
                self.makeRequest(endpoint: MaguenCredentials.getModifyID, soapMessage: soapXML)
            }
            
        }
        catch let jsonErr{
            print("getTablesList error: \(jsonErr)")
        }
        
    }
    
    func getIDList(){
        do {
            
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapResult.decryptBase64ToString(cipher: aes)
            
            let idTablesResult = try jsonDecoder.decode(GetModifyTablesResponse.self, from: Data(decrypted.utf8))
            
            
            idToSync = idTablesResult.Value.components(separatedBy: "@")
            for i in 0...(idToSync.count - 1) {
                print(idToSync[i])
            }
            
            
        }
        catch let jsonErr{
            print("getTablesList error: \(jsonErr)")
        }
    }
}
