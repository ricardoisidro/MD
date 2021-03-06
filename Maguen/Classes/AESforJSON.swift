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
            ////print(jsonString)
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
            ////print(jsonString)
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
            ////print(jsonString)
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err {
            print("encodeAndEncryptJSONEntityString error: \(err)")
        }
        return cipherRequest
    }
    
    func encodeAndEncryptJSONGetUsuarioApp(LoginRequest: pGetUsuarioApp) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(LoginRequest)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err{
            print("encodeAndEncryptJSONGetUsuarioApp error: \(err)")
        }
        return cipherRequest
    }
    
    func decodeAndDecryptJSONGetUsuarioApp(soapResult: String) -> EBReturnUserApp {
        do {
            //let res = EBReturnUserApp()
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapResult.decryptBase64ToString(cipher: aes)
            print(decrypted)
            let loginResult = try jsonDecoder.decode(EBReturnUserApp.self, from: Data(decrypted.utf8))
            return loginResult
        }
        catch let ex {
            print("decodeAndDecryptJSONGetUsuarioApp error: \(ex)")
            //decodeAndDecryptErrorGetUsuarioApp(soapResult: soapResult)
            return EBReturnUserApp()
        }
    }
    
    /*func decodeAndDecryptErrorGetUsuarioApp(soapResult: String) -> EBReturnError {
        do {
            //let res = EBReturnUserApp()
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapResult.decryptBase64ToString(cipher: aes)
            print(decrypted)
            let loginResult = try jsonDecoder.decode(EBReturnUserApp.self, from: Data(decrypted.utf8))
            return loginResult
        }
        catch let ex {
            print("decodeAndDecryptJSONGetUsuarioApp error: \(ex)")
            
            return EBReturnUserApp()
        }
    }*/
    
    func encodeAndEncryptJSONNotificationsString(request: NotificationRequest) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData: Data
            jsonData = try jsonEncoder.encode(request)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            ////print(jsonString)
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err {
            print("encodeAndEncryptJSONNotificationString error: \(err)")
        }
        return cipherRequest
    }
    
    func encodeAndEncryptJSONQRString(id: Int) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        let getQR = GetDinamicWeganRequest(usuario_app_id: id)
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData: Data
            //let getModifyTable
            jsonData = try jsonEncoder.encode(getQR)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            ////print(jsonString)
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err {
            print("encodeAndEncryptJSONTablesString error: \(err)")
        }
        return cipherRequest
    }
    
    func encodeAndEncryptJSONSaldo(SaldoRequest: SaldoRequest) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(SaldoRequest)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err {
            print("encodeAndEncryptJSONString error: \(err)")
        }
        return cipherRequest
    }
    
    func decodeAndDecryptJSONSaldo(soapResult: String) -> String {
        var saldo = "$ PENDIENTE"
        do {
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            var decrypted = try soapResult.decryptBase64ToString(cipher: aes)
            ////print("Cadena decrypted saldo: \(decrypted)")
            
            let saldoResult = try jsonDecoder.decode(SaldoResponse.self, from: Data(decrypted.utf8))
            if saldoResult.Correcto {
                UserDefaults.standard.set(saldoResult.Value, forKey: "balance")
                saldo = saldoResult.Value
            }
            
        }
        catch let ex {
            print("decodeAndDecryptJSONSaldo error: \(ex)")
        }
        return saldo
    }
    
    
    func encodeAndEncryptJSONSetUsuarioApp(objeto: pSetUsuarioApp) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(objeto)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            //print(jsonString)
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err {
            print("encodeAndEncryptJSONString error: \(err)")
        }
        return cipherRequest
    }
    
    func decodeAndDecryptJSONSetUsuarioApp(soapResult: String) -> EBReturn {
       
        do {
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            var decrypted = try soapResult.decryptBase64ToString(cipher: aes)
            ////print("Cadena decrypted saldo: \(decrypted)")
            
            let ebResult = try jsonDecoder.decode(EBReturn.self, from: Data(decrypted.utf8))
            return ebResult
            
        }
        catch let ex {
            print("decodeAndDecryptJSONSetUsuarioApp error: \(ex)")
            return EBReturn()
        }
        //return saldo
    }
    
    func encodeAndEncryptJSONConsultarSaldo(objeto: String) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        let pdetalle = pDetalleSaldo()
        pdetalle.num_socio = objeto
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(pdetalle)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            //print(jsonString)
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err {
            print("encodeAndEncryptJSONString error: \(err)")
        }
        return cipherRequest
    }
    
    func decodeAndEncryptJSONConsultarSaldo(soapResult: String) -> EBReturn2 {
        
        do {
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            var decrypted = try soapResult.decryptBase64ToString(cipher: aes)
            //print("Cadena decrypted saldo: \(decrypted)")
            
            let ebResult = try jsonDecoder.decode(EBReturn2.self, from: Data(decrypted.utf8))
            return ebResult
            
        }
        catch let ex {
            print("decodeAndEncryptJSONConsultarSaldo error: \(ex)")
            return EBReturn2()
        }
        //return saldo
    }
    
    
    
}
