//
//  Global.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/21/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import SQLite

class Global {

    static let shared = Global()
    
    var loginOk = false
    var indexItemTabSelected = -1
    //var database: Connection!
    
    init() {
      
    }
    
    
    
    func createSOAPXMLString(methodName: String, encryptedString: Array<UInt8>) -> String {
        //static let soapString: String = ""
        let soapString = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(methodName) xmlns='http://tempuri.org/'><Cadena>\(encryptedString.toBase64()!)</Cadena><Token></Token></\(methodName)></soap:Body></soap:Envelope>"
        
        return soapString
    }
    
    /*func createDBFile() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let database = try Connection(fileURL.path)
            self.database = database
        }
        catch let ex {
            //print("createDBFile error: \(ex)")
        }
    }*/
}
