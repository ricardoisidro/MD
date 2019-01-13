//
//  EBReturn.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/12/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import Foundation

class EBReturn: NSObject, Decodable {
    
    var Correcto: Bool
    var MensajeError: String
    var ex: String?
    var Incorrecto: Bool
    var Value: String?
    
    override init() {
        
        self.Correcto = false
        self.MensajeError = ""
        self.ex = ""
        self.Incorrecto = false
        self.Value = nil
        
    }
}
