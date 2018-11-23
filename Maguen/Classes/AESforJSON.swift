//
//  AESforJSON.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/21/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import CryptoSwift

class AESforJSON {
    
    
    func encodeAndEncryptJSONTablesString(fecha: String) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        let getModifyTablesRequest = GetModifyTablesRequest(FechaSincronizacion: fecha)
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData: Data
            //let getModifyTable
            jsonData = try jsonEncoder.encode(getModifyTablesRequest)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            //print(jsonString)
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err {
            print("encodeAndEncryptJSONTablesString error: \(err)")
        }
        return cipherRequest
    }
    
    func encodeAndEncryptJSONIDsString(fecha: String, tableName: String) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        let getIDRequest = GetIDRequest(FechaSincronizacion: fecha, Table: tableName)
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData: Data
            //let getModifyTable
            jsonData = try jsonEncoder.encode(getIDRequest)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            //print(jsonString)
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err {
            print("encodeAndEncryptJSONIDsString error: \(err)")
        }
        return cipherRequest
    }
    
    func encodeAndEncryptJSONEntityString(tableName: String, id: String) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        let getEntityRequest = GetEntityRequest(ID: id, Table: tableName)
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData: Data
            jsonData = try jsonEncoder.encode(getEntityRequest)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            //print(jsonString)
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err {
            print("encodeAndEncryptJSONEntityString error: \(err)")
        }
        return cipherRequest
    }
    
     
}
