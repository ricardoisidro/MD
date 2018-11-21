//
//  MyClass.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/20/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import CryptoSwift

class MyClass {
    
    func encodeAndEncryptJSONString(GetModifyTablesRequest: GetModifyTablesRequest) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(GetModifyTablesRequest)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err {
            print("encodeAndEncryptJSONString error: \(err)")
        }
        return cipherRequest
    }
}
