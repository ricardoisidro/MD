//
//  DomicilioModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/27/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation

class DomicilioModel: NSObject {
    
    var domicilio_id: Int
    var calle: String
    var numero_exterior: String
    var numero_interior: String
    var cp: Int?
    var colonia: String
    var delegacion_municipio: String
    var estado: String
    var fecha_modificacion: String?
    
    override init() {
        self.domicilio_id = -1
        self.calle = ""
        self.numero_exterior = ""
        self.numero_interior = ""
        self.cp = -1
        self.colonia = ""
        self.delegacion_municipio = ""
        self.estado = ""
        self.fecha_modificacion = ""
    }
    
    static func deserializaCentro(dato: String) -> DomicilioModel {
        let domicilio = DomicilioModel()
        
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "domicilio_id"){
                domicilio.domicilio_id = Int(val[1])!
            }
            else if(val[0] == "calle") {
                domicilio.calle = val[1]
            }
            else if(val[0] == "numero_exterior") {
                domicilio.numero_exterior = val[1]
            }
            else if(val[0] == "numero_interior") {
                domicilio.numero_interior = val[1]
            }
            else if(val[0] == "colonia") {
                domicilio.colonia = val[1]
            }
            else if(val[0] == "delegacion_municipio") {
                domicilio.delegacion_municipio = val[1]
            }
            else if(val[0] == "estado") {
                domicilio.estado = val[1]
            }
            else if(val[0] == "fecha_modificacion") {
                domicilio.fecha_modificacion = val[1]
            }
            
        }
        
        return domicilio
        
    }
}
