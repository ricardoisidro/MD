//
//  MyClass.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/20/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import CryptoSwift

class MyClass : NSObject, XMLParserDelegate {
    
    var soapString: String = ""
    var currentParsingElement: String = ""
    var idToSync: [String] = [String]()
    
    //MARK:- XMLParserDelegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsingElement = elementName
        if elementName == "GetIDsResponse" {
            //print("Started parsing modifytables...")
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            if currentParsingElement == "GetIDsResult"{
                self.soapString = ""
                self.soapString += foundedChar
            }
            else {
                self.soapString += "nothing"
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "GetIDsResponse" {
            //print("Ended parsing modifytables...")
            
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.getIDList()
            //self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
    
    func getIDList(){
        do {
            
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapString.decryptBase64ToString(cipher: aes)
            
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
