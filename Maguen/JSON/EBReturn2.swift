//
//  EBReturn2.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/14/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import Foundation

class EBReturn2: NSObject, Decodable {
    
    var Correcto: Bool
    var MensajeError: String
    var ex: String?
    var Incorrecto: Bool
    var Value: [Value3]  = [Value3]()
    
    override init() {
        
        self.Correcto = false
        self.MensajeError = ""
        self.ex = ""
        self.Incorrecto = false
        self.Value = []
        
    }
}

class Value3: NSObject, Decodable {
    
    var CLICOD: String
    var DNUM: String
    var IDESCR: String
    var DCANT: Float
    var DFECHA: String
    var DVENCE: String
    
    override init() {
        self.CLICOD = ""
        self.DNUM = ""
        self.IDESCR = ""
        self.DCANT = 0.0
        self.DFECHA = ""
        self.DVENCE = ""
    }
    
}
