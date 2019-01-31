//
//  LoginResponse.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/14/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation

class EBReturnUserApp: NSObject, Decodable {
    
    var Value: jsUsuarioApp
    var Correcto: Bool
    var MensajeError: String
    var ex: String?
    var Incorrecto: Bool
    
    override init() {
        
        self.Correcto = false
        self.MensajeError = ""
        self.ex = ""
        self.Incorrecto = false
        self.Value = jsUsuarioApp()
        
    }
}
