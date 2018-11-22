//
//  Global.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/21/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation

class Global {

    static let shared = Global()
    
    init() {}
    
    func createSOAPXMLString(methodName: String, encryptedString: Array<UInt8>) -> String {
        //static let soapString: String = ""
        let soapString = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><\(methodName) xmlns='http://tempuri.org/'><Cadena>\(encryptedString.toBase64()!)</Cadena><Token></Token></\(methodName)></soap:Body></soap:Envelope>"
        
        return soapString
    }
    
    
    var tablesAreFilled = false
}
